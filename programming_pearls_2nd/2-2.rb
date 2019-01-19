require 'minitest/autorun'

# シーケンシャルなファイル = ソート済み？

# ここでは、43億個の代わりに↓の配列を使う
input = [1,2,3,4,4,5,6,7,8,9,9,10]

# 4_300_000_000 - 2**32

result = []
input.each_cons(2) do |a, b|
  result << a if a == b
end

describe "2-2" do
  it "should count duplicates" do
    assert_equal [4, 9], result
  end
end
