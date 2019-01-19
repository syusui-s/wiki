require 'minitest/autorun'

# メモリの使用量を抑えるパターンを実装してみる。
# ただ、これは前のお手玉方式と同様に
# メモリの局所性は低いため、tが大きな場合には、
# 他の方式に比べて遅くなると思われる。

# @param t 値
# @param k tを超えない部分配列の長さ
def calc(input, t, k)
  i = 0
  sum = input[0...k].sum

  return true if sum <= t

  while i < (input.length - k)
    sum -= input[i]
    sum += input[i+k]

    return true if sum <= t

    i += 1
  end

  false
end

describe '2-8' do
  it 'should return true' do
    assert_equal true, calc([5, 4, 1], 10, 2)
  end

  it 'should return true' do
    assert_equal true, calc([5, 5, 1], 10, 2)
  end

  it 'should return true' do
    assert_equal true, calc([1, 5, 5], 10, 2)
  end

  it 'should return false' do
    assert_equal false, calc([5, 6, 5], 10, 2)
  end

  it 'should return false' do
    assert_equal false, calc([6, 5, 6], 10, 2)
  end
end
