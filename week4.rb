require 'uri'
require 'net/http'

def hex2codes(s)
  s.scan(/../).map {|code| code.to_i(16) }
end

def codes2hex(codes)
  codes.map {|c| c.to_s(16).rjust(2, '0') }.join
end

def codes2str(codes)
  codes.map {|c| c.nil? ? '' : c.chr }.join
end

def test(ct)
  uri = URI("http://crypto-class.appspot.com/po")
  uri.query = URI.encode_www_form(er: ct)
  resp = Net::HTTP.get_response(uri)
  resp
end

def padding_guess(codes, g, c, l, result)
  ary = codes.dup
  padding = result.dup
  padding[c] = g
  p padding
  p codes2str(padding)
  l.times do |i|
    ary[c+i] = ary[c+i]^padding[c+i]^l
  end
  ary
end

# 16 bytes
def attack(head, b1, b2)
  codes1 = hex2codes(b1)
  codes2 = hex2codes(b2)

  result = []
  16.times do |i|
    c = 15-i
    l = 16-c

    255.times do |g|
      padded_block = padding_guess codes1, g, c, l, result
      fake = head + codes2hex(padded_block) + b2

      oracle = test(fake).code
      if oracle == '403' # padding error
        # do nothing, next try
      elsif oracle == '404' # padding success!
        result[c] = g
        break
      elsif 
        p fake
        puts "error! oracle=#{oracle}"
      end
    end

    result[c] ||= l # because we don't count 200 success and no 404 found, so 200 is the only possibility
  end

  result
end

# 64 bytes, IV + 3 blocks, 16 bytes each
ct = 'f20bdba6ff29eed7b046d1df9fb7000058b1ffb4210a580f748b4ac714c001bd4a61044426fb515dad3f21f18aa577c0bdf302936266926ff37dbf7035d5eeb4'
iv = ct[0, 32]
blocks = [ct[32, 32], ct[64, 32], ct[96, 32]]

b2 = attack(iv+blocks[0], blocks[1], blocks[2])
b1 = attack(iv, blocks[0], blocks[1])
b0 = attack('', iv, blocks[0])
p codes2str(b0)
p codes2str(b1)
p codes2str(b2)

# The Magic Words are Squeamish Ossifrage
