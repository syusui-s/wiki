# 0 .. (n-1) の配列
arr = (0...n).to_a

i = 0
while i < n
  # iより後ろの適当な場所とiを置き換えるようにする
  idx = i + rand(n - i)
  puts arr[i] = arr[idx]
  arr[idx] = i
  i+=1
end
