def to_codes(s)
  s.scan(/../).map {|code| code.to_i(16) }
end

l20 = gets.chomp
l21 = gets.chomp

codes20 = to_codes(l20)
codes21 = to_codes(l21)

(0...codes20.size).each do |i|
  print(codes20[i] ^ codes21[i])
end
puts "\n"
