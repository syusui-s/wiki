require 'minitest/autorun'

def sort(input)
  input.chars.sort.join
end

def list_anagram(dicts, input)
  sorted = sort(input)

  dicts = dicts.group_by(&method(:sort))

  dicts[sorted]
end

describe "list_anagram" do
  it "should return anagrams" do
    dicts = %w{
      caid
      goal
      acid
      cadi
      algo
      gaol
      aglo
    }
    input = "goal"

    words = list_anagram(dicts, input)

    assert_equal %w{goal algo gaol aglo}, words
  end
end
