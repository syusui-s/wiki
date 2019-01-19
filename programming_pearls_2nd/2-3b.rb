# 反転繰り返し方式

# input:
#   array = abcdef
#   i     = 3
# output  = defabc

# i=3
# Initial   a b c d e f
# Reverse 1 c b a|d e f
# Reverse 2 c b a|f e d
# Reverse A d e f a b c

# i=2
# -- 0
# Initial   a b c d e f
#           ^A  ^Bl ^Br
# Move    1 e f c d a b
#           ^A  ^B
# Move    2 c d e f a b

require 'minitest/autorun'

def rot_left(arr, i)
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
