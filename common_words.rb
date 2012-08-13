class CommonWords
  def initialize(string)
    @string = string
  end
  
  def common(number)
    
  end
  
  def self.sorter
    a = "I I I I am a test string test string test".strip.downcase.split(/[^\w']+/).sort
    b = Hash.new{0}
    a.each do |v|
      b[v] += 1
    end
    
    b.sort_by {|k, v| v }.reverse!.each do |k, v|
      puts "#{k} appears #{v} times"
    end
  end
  
  # split words
  # sort
  # ?
end

CommonWords.sorter

# require 'minitest/autorun'
# 
# class CommonWordsSpec < MiniTest::Spec  
#   it "accepts a string as input"
#   it "accepts a text file as input"
#   
#   it "returns a Document object with statistics"
# 
#   it "returns stats on the X most common words"
#   it "returns stats on all the words"
#   
#   it "counts word stems"
# end