require 'pathname'
require 'tempfile'

# ハッシュタグクラスとパス参照クラス分けたほうが良いかも
Reference = Struct.new(:name) do
  def is_hashtag?
    name.start_with?('#')
  end

  def is_path?
    ! is_hashtag?
  end

  def to_path(basedir: '')
    base = Pathname.new(basedir)

    case
    when is_hashtag?
      path = '../' * base.descend.count
      Pathname.new(path) / "#{name[1..-1]}.md"
    when is_path?
      "#{name}.md"
    end
  end
end

# name (String): 名前
# path (Pathname): Pathname
# references ([names]): 参照先
Page = Struct.new(:name, :path, :references, :references_resolved) do
  def self.from_file(path)
    name = nil
    references = []
    references_resolved = []
    probably_name = nil
     
    File.open(path) do |f|
      f.each_line.each_with_index do |l, i|
        case
        when match = l.match(/^\[(.*)\]$/)
          references << Reference.new(match[1])
        when match = l.match(/^\[(.*)\]: /)
          references_resolved << Reference.new(match[1])
        when i == 0
          if match = l.match(/^# (.*)$/)
            name = match[1]
          else
            probably_name = l
          end
        when i == 1 && !probably_name.nil? && i == 1 && l.match(/^=+$/)
          name = probably_name
        end
      end
    end

    new(name, Pathname.new(path), references, references_resolved)
  end

  def refers?(name)
    self.references.any?{|ref| ref.name == name }
  end

  def append_reference_path_definitions_to_file(all: false)
    reftag = "<!-- :: REFERENCES :: -->"

    references_append = all ? self.references : (self.references - self.references_resolved)
    dir = self.path.dirname

    return if references_append.empty?

    temp = File.open("#{self.path}.tmp", "w")

    File.open(path, "r+") do |f|
      f.each_line {|l|
        break if l.strip == reftag
        temp.print l
      }
      temp.puts "#{reftag}\n"
    end

    references_append.each do |ref|
      temp.puts "[%s]: %s\n" % [ref.name, ref.to_path(basedir: dir)]
    end

    temp.close

    FileUtils.mv(temp.path, path)
  end
end

Pages = Struct.new(:pages) do
  def self.from_array(array)
    map = Hash.new
    array.each{|page| map[page.name] = page }

    new(map)
  end

  def find_referers(name)
    self.pages.values.select { |p| p.refers?(name) }
  end

  def append_reference
    self.pages.values.each { |p| p.append_reference_path_definitions_to_file }
  end

  def append_referer
    reftag = "<!-- :: REFERERS :: -->"

    self.pages.values.each do |p|
      referers = self.find_referers(p.name)

      temp = File.open("#{p.path}.tmp", "w")

      File.open(p.path, "r+") do |f|
        f.each_line.find {|l|
          break if l.strip == reftag
          temp.print l
        }
      end
 
      temp.puts "#{reftag}\n"

      temp << "\n---\n" 
      temp << "リファラ: \n\n"

      referers.each do |ref|
        path = ref.path.relative_path_from(p.path.dirname)
        temp << "* [#{ref.name}](#{path})\n"
      end

      temp.close

      FileUtils.mv(temp.path, p.path)
    end
  end
end

file_paths = Dir.glob('**/*.md')

pp pages = Pages.from_array(
  file_paths.map{|fp| Page.from_file(fp) }
)

puts "-- append reference"
pages.append_reference

puts "-- append referer"
pages.append_referer
