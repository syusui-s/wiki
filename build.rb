require 'pathname'

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

  def append_reference_path_definitions_to_file(all: false)
    references_append = all ? self.references : (self.references - self.references_resolved)
    dir = self.path.dirname

    return if references_append.empty?

    File.open(path, "a+") do |f|
      append = String.new

      append << "\n---\n\n"
      references_append.each do |ref|
        append << "[%s]: %s\n" % [ref.name, ref.to_path(basedir: dir)]
      end

      f << append
    end
  end
end

Pages = Struct.new(:pages) do
  def self.from_array(array)
    map = Hash.new
    array.each{|page| map[page.name] = page }

    new(map)
  end
end

file_paths = Dir.glob('**/*.md')

pp pages = Pages.from_array(
  file_paths.map{|fp| Page.from_file(fp) }
)

pages.pages.values.each{|p| p.append_reference_path_definitions_to_file }
