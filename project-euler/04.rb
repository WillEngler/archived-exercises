# Find the largest palindrome made from the product of two 3-digit numbers.

def largestPalindrome
  largest = 0
  (100..999).each do |x|
    (100..999).each do |y|
      product = x*y
      largest = product if palindrome? product and product > largest
    end
  end
  largest
end

def palindrome?(num)
  num_str = num.to_s
  num_str.reverse == num_str
end

puts largestPalindrome