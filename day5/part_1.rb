# frozen_string_literal: true

text = File.open(__dir__ + '/input.txt').read

input = text.chomp.split(',').map(&:to_i)

needle_position = 0
halt = false

until halt
  if input[needle_position] == 99
    halt = true
    next
  end

  # ABCDE
  # DE = OP_CODE - 2 DIGITS
  # C  = First parameter mode
  # B  = Second parameter mode
  # A  = Third parameter mode
  parameter_hash = input[needle_position].digits.reverse
  op_code        = parameter_hash[-2, 2]&.join || parameter_hash[-1]
  mode_1         = parameter_hash[-3]
  mode_2         = parameter_hash[-4]
  mode_3         = parameter_hash[-5]

  op_code = op_code.to_i

  if op_code == 1
    x = if !mode_1 || mode_1 == 0
          input[input[needle_position + 1]]
        else
          input[needle_position + 1]
        end
    y = if !mode_2 || mode_2 == 0
          input[input[needle_position + 2]]
        else
          input[needle_position + 2]
        end
    input[input[needle_position + 3]] = x + y
    needle_position += 4
  elsif op_code == 2
    x = if !mode_1 || mode_1 == 0
          input[input[needle_position + 1]]
        else
          input[needle_position + 1]
        end
    y = if !mode_2 || mode_2 == 0
          input[input[needle_position + 2]]
        else
          input[needle_position + 2]
        end
    input[input[needle_position + 3]] = x * y
    needle_position += 4
  elsif op_code == 3
    puts 'Insert code'
    x = gets.chomp.to_i
    input[input[needle_position + 1]] = x
    needle_position += 2
  elsif op_code == 4
    x = input[input[needle_position + 1]]
    puts x
    needle_position += 2
  end
end

puts 'halt'
