# 問題1 さっきの問題、セットやソートがあるならどう実装する？

# Setを使う例
set = []
while num = gets&.to_i
  set[num] = true
end

set.each_with_index.select{|b, _| b }.each{|e| puts e[1] }
