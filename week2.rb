require 'openssl'

def encrypt(k, pt)
  aes = OpenSSL::Cipher.new('AES128')
  aes.encrypt
  aes.padding = 0
  aes.key = k
  aes.update(pt) + aes.final
end

def decrypt(k, ct)
  aes = OpenSSL::Cipher.new('AES128')
  aes.decrypt
  aes.padding = 0
  aes.key = k
  aes.update(ct) + aes.final
end

def xor(b1, b2)
  bytes1 = b1.bytes
  bytes2 = b2.bytes

  size = [bytes1.size, bytes2.size].min
  (0...size).map do |i|
    (bytes1[i] ^ bytes2[i]).chr
  end.join
end

def cbc_decrypt(k, ivct)
  k = k.scan(/../).map{|c| c.to_i(16).chr }.join
  ivct = ivct.scan(/../).map{|c| c.to_i(16).chr }.join
  iv = ivct[0,16]
  ct = ivct[16..-1]

  pt = ''
  parsed = ''
  cur = 0
  loop do
    cb = ct[cur, 16]
    parsed += cb
    pb = decrypt(k, cb)
    m = xor(pb, iv)
    iv = cb
    cur += 16

    if parsed == ct # last block
      padding = m.bytes.last
      size = m.size - padding
      if size > 0
        m = m[0, size]
        pt += m
      end
      break
    else
      pt += m
    end
  end

  pt
end

def ctr_decrypt(k, ivct)
  k = k.scan(/../).map{|c| c.to_i(16).chr }.join
  iv = ivct[0,32].to_i(16)
  ct = ivct[32..-1].scan(/../).map{|c| c.to_i(16).chr }.join

  pt = ''
  parsed = ''
  cur = 0
  loop do
    cb = ct[cur, 16]
    parsed += cb
    t = iv.to_s(16).scan(/../).map{|c| c.to_i(16).chr }.join
    mask = encrypt(k, t)
    pt += xor(cb, mask)
    iv += 1
    cur += 16

    break if parsed == ct # last cipher block
  end

  pt
end

key = '140b41b22a29beb4061bda66b6747e14'
ct = '4ca00ff4c898d61e1edbf1800618fb2828a226d160dad07883d04e008a7897ee2e4b7465d5290d0c0e6c6822236e1daafb94ffe0c5da05d9476be028ad7c1d81'
p cbc_decrypt(key, ct)

key = '140b41b22a29beb4061bda66b6747e14'
ct = '5b68629feb8606f9a6667670b75b38a5b4832d0f26e1ab7da33249de7d4afc48e713ac646ace36e872ad5fb8a512428a6e21364b0c374df45503473c5242a253'
p cbc_decrypt(key, ct)

key = '36f18357be4dbd77f050515c73fcf9f2'
ct = '69dda8455c7dd4254bf353b773304eec0ec7702330098ce7f7520d1cbbb20fc388d1b0adb5054dbd7370849dbf0b88d393f252e764f1f5f7ad97ef79d59ce29f5f51eeca32eabedd9afa9329'
p ctr_decrypt(key, ct)

key = '36f18357be4dbd77f050515c73fcf9f2'
ct = '770b80259ec33beb2561358a9f2dc617e46218c0a53cbeca695ae45faa8952aa0e311bde9d4e01726d3184c34451'
p ctr_decrypt(key, ct)
