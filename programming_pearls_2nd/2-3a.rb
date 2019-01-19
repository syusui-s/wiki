# お手玉方式

# input:
#   array = abcdef
#   i     = 2
# output  = cdefab

# abcdef
# ^ ^ ^ 
#  / / / 
# v v v
# cbedaf 
#  ^ ^ ^
# / / / 
#  v v v
# cdefab

require 'minitest/autorun'

def rot_left(arr, i)
  arr = arr.clone

  y = 0
  while y < i
    x = y
    t = arr[x]
    while x < arr.length - i
      arr[x] = arr[x+i]
      x += i
    end
    arr[x] = t
    y += 1
  end

  arr
end

describe "2-3a" do
  it "should return correct value when i = 2" do
    assert_equal "cdab".chars,   rot_left("abcd".chars, 2)
  end

  it "should return correct value when i = 3" do
    assert_equal "defabc".chars, rot_left("abcdef".chars, 3)
  end

  it "should return correct value when i = 4" do
    assert_equal "efghabcd".chars, rot_left("abcdefgh".chars, 4)
  end

  it "should return correct value when i = 4" do
    assert_equal "efghijklabcd".chars, rot_left("abcdefghijkl".chars, 4)
  end
end
