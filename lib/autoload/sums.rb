module Sums
  
  def self.column(x)
    tot = 0
    x.gsub("\n", '+').split('+').each do |y|
      tot += y.to_i
    end
    tot
  end
  
end
