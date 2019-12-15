# frozen_string_literal: true

input = '168630-718098'.split('-').map(&:to_i)

count = 0

(input[0]..input[1]).each do |password|
  # inject actually return [ 2-digit-valid, crescent-valid, last_digit ]
  validation = password.digits.reverse.inject([false, true, -1]) do |memo, digit|
    [
      (digit == memo[2]) || memo[0],
      digit >= memo[2] && memo[1],
      digit
    ]
  end

  count += 1 if validation[0] && validation[1]
end

puts count
