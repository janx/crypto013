require 'gmp'

def brute_force_attack(pn, g, h)
  pn = GMP::Z.new(pn)
  g  = GMP::Z.new(g)
  h  = GMP::Z.new(h)
  b  = GMP::Z.new(2**40)

  for i in (0..b)
    p i
    v = g.powmod(i, pn)
    return i if v == h
  end
end

def mitm_attack(pn, g, h, b)
  pn = GMP::Z.new(pn)
  g  = GMP::Z.new(g)
  h  = GMP::Z.new(h)
  b  = GMP::Z.new(b)
  base = g.powmod(b, pn)

  puts "Building hash .."
  hash = {}
  (0..b).each do |i|
    p i
    v = (h*(g.powmod(i, pn).invert(pn)))%pn
    hash[v] = i
  end

  for x0 in (0..b)
    p "Test x0: #{x0}"
    if x1 = hash[base.powmod(x0, pn)]
      x = b*x0 + x1
      return x
    end
  end
end

pn = 13407807929942597099574024998205846127479365820592393377723561443721764030073546976801874298166903427690031858186486050853753882811946569946433649006084171
g = 11717829880366207009516117596335367088558084999998952205599979459063929499736583746670572176471460312928594829675428279466566527115212748467589894601965568
h = 3239475104050450443565264378728065788649097520952449527834792452971981976143292558073856937958553180532878928001494706097394108577585732452307673444020333
b = 2**20

#pn = 13
#g = 2
#h = 3
#b = 4

p brute_force_attack(pn, g, h)

#p mitm_attack(pn, g, h, b)
#375374217830
#31.37user 4.39system 0:35.84elapsed 99%CPU (0avgtext+0avgdata 343952maxresident)k
#0inputs+26600outputs (0major+89594minor)pagefaults 0swaps
