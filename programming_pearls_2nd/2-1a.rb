require 'minitest/autorun'

def sort(input)
  input.chars.sort.join
end

def list_anagram(dicts, input)
  sorted = sort(input)

  dicts.select do |word|
    sort(word) == sorted
  end
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
