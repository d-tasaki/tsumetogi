require 'tsumetogi'

# Never ending dividable numbers
module Tsumetogi
  class PageNum

    MAX = 0x100000000

    # Interpolate n points between x and y
    def self.lerp(x, y, n)
      x0 = [x, y].min
      x1 = [x, y].max
      dx = (x1 - x0) / (n + 1)

      ret = n.times.map do |i|
        x0 + dx * (i + 1)
      end
      ret.reverse! if x0 != x
      ret
    end

    def initialize(obj = nil)
      case obj
      when Array, nil
        @digits = obj
      when String
        @digits = obj.split("_").map(&:hex)
      when Numeric
        @digits = [obj]
      when PageNum
        @digits = obj.digits.dup
      else
        raise "Unknown object was given to create a PageNum object: #{obj.inspect}"
      end
    end

    def <=>(other)
      self.each_other(other) do |a, b|
        ret = a <=> b
        return ret if ret.nonzero?
      end
      0
    end

    def +(other)
      carry = 0
      ret = self.reverse_each_other(other).map do |a, b|
        carry, sum = (carry + a + b).divmod(MAX)
        sum
      end

      if carry.zero?
        self.class.new(ret.reverse)
      else
        Infinity
      end
    end

    def -(other)
      borrow = 0
      ret = self.reverse_each_other(other).map do |a, b|
        borrow, diff = (borrow + a - b).divmod(MAX)
        diff
      end

      if borrow.zero?
        self.class.new(ret.reverse)
      else
        self.class.new
      end
    end

    def *(n)
      carry = 0
      ret = self.digits.reverse.map do |d|
        carry, mul = (carry + d * n).divmod(MAX)
        mul
      end

      if carry.zero?
        self.class.new(ret.reverse)
      else
        Infinity
      end
    end

    def /(n)
      decimal = 0
      ret = self.digits.map do |d|
        div = (MAX * decimal + d).quo(n)
        decimal = div - div.to_i
        div.to_i
      end

      ret << MAX * decimal if decimal.nonzero?
      self.class.new(ret)
    end

    def to_s(size = nil)
      self.compact.padding(size)

      hexes = self.digits.map do |d|
        "%08x" % d
      end

      hexes.join('_')
    end

    protected

    def digits
      @digits ||= [default_value]
    end

    def default_value
      0
    end


    def zip(other)
      size = [self.digits.size, other.digits.size].max
      self.padding(size)
      other.padding(size)
      self.digits.zip(other.digits)
    end

    def each_other(other, &block)
      if block_given?
        self.zip(other).each &block
      else
        self.zip(other).each
      end
    end

    def reverse_each_other(other, &block)
      if block_given?
        self.zip(other).reverse_each &block
      else
        self.zip(other).reverse_each
      end
    end

    def padding(n)
      return self if n.nil?

      (n - self.digits.size).times.each do
        self.digits << default_value
      end

      self
    end

    def compact
      while(self.digits.size > 1) do
        if self.digits.last == default_value
          self.digits.pop
        else
          break
        end
      end

      self
    end

  end

  PageNum::Infinity = PageNum.new
  class << PageNum::Infinity
    protected 
    def default_value
      MAX - 1
    end
  end

end
