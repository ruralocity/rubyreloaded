class FizzBuzz
  def self.check(num)
    if num.class.name == 'Fixnum'
      out = case
      when do_math(num,15)
        "FizzBuzz"
      when do_math(num,3)
        "Fizz"
      when do_math(num,5)
        "Buzz"
      else
        num
      end
    
      out
    else
      num
    end
  end
  
  def self.count(*range)
    count = []
    range.each do |item|
      count << check(item)
    end
    count.join(', ')
  end
  
  private
  
  def self.do_math(num,divisible_by)
    num-divisible_by*(num/divisible_by).floor == 0
  end
end

if __FILE__ == $0
  require 'minitest/autorun'
  
  class FizzBuzzSpec < MiniTest::Spec
    it "returns a number for non-multiples of 3 or 5" do
      FizzBuzz.check(1).must_equal 1
    end
  
    it "returns fizz for multiples of 3 but not 5" do
      FizzBuzz.check(3).must_equal "Fizz"
    end
    
    it "returns buzz for multiples of 5 but not 3" do
      FizzBuzz.check(5).must_equal "Buzz"
    end
    
    it "returns fizzbuzz for multiples of 3 and 5" do
      FizzBuzz.check(15).must_equal "FizzBuzz"
    end

    it "doesn't try to check strings" do
      FizzBuzz.check("fizzer").must_equal "fizzer"
    end
    
    it "doesn't try to check floats" do
      FizzBuzz.check(1.2).must_equal 1.2
    end
    
    it "counts fizzbuzz-style for a given set of numbers" do
      FizzBuzz.count(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20).must_equal "1, 2, Fizz, 4, Buzz, Fizz, 7, 8, Fizz, Buzz, 11, Fizz, 13, 14, FizzBuzz, 16, 17, Fizz, 19, Buzz"
    end
    
    it "accepts unusual arrays" do
      FizzBuzz.count("one",2,3,15,0.9).must_equal "one, 2, Fizz, FizzBuzz, 0.9"
    end
    
    # it "accepts ranges" do
    #   FizzBuzz.count(1..5).must_equal "1, 2, Fizz, 4, Buzz"
    # end
  end
end