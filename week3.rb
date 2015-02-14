require 'openssl'

def h(file)
  File.open(file, 'rb') do |f|
    n = f.stat.size/1024
    h = nil
    (0..n).to_a.reverse.each do |i|
      f.seek i*1024, IO::SEEK_SET
      block = f.read 1024
      m = h ? block+h : block
      h = OpenSSL::Digest::SHA256.new.digest(m)
    end
    puts h.bytes.map {|c| c.to_s(16).rjust(2, '0') }.join
  end
end

h ARGV[0]
