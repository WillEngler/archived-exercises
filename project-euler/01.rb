# Find the sum of all the multiples of 3 or 5 below 1000.

puts ((1...1000).select {|num| num % 3 == 0 or num % 5 == 0 }).reduce(:+)