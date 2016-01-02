# By considering the terms in the Fibonacci sequence whose values do not exceed four million, find the sum of the even-valued terms.

def sumOfEvenFibonaccis
  fib_seq = [1, 2]
  while fib_seq.last < 4000000
    fib_seq.push(fib_seq[-1] + fib_seq[-2])
  end
  fib_seq.pop
  fib_seq.delete_if(&:odd?).reduce(:+)
end

puts sumOfEvenFibonaccis