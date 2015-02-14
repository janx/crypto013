iv = '20814804c1767293b99f1d9cab3bc3e7'
ct = 'ac1e37bfb15599e5f40eef805488281d'
pt = 'Pay Bob 100$'

def hex2codes(s)
  s.scan(/../).map {|code| code.to_i(16) }
end

def codes2hex(codes)
  codes.map {|c| c.to_s(16).rjust(2, '0') }.join
end

p iv.size
p ct.size
p pt.size
p hex2codes(iv)
iv2 = [32, 129, 72, 4, 193, 118, 114, 147, 189, 159, 29, 156, 171, 59, 195, 231]
p  codes2hex(iv2)
