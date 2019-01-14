class Bits
  def initialize
    @bits = []
  end

  def set(index)
    raise ::ArgumentError, "範囲外です" unless index > 0

    idx = bits_index(index)
    val = bits_value(index, idx)

    @bits[idx] ||= 0
    @bits[idx] |= val

    nil
  end

  def get(index)
    raise ::ArgumentError, "範囲外です" unless index > 0

    idx = bits_index(index)
    val = bits_value(index, idx)

    (@bits[idx] || 0) & val > 0
  end

  private
  def bits_index(index)
    index >> 5
  end

  def bits_value(index, bits_idx)
    1 << (index - (bits_idx << 5))
  end
end

x = Bits.new
(10 ** 7).times {|e|
  x.set(e+1)
}
p (10 ** 7).times.all? {|e|
  x.get(e+1)
}
