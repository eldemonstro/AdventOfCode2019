require 'pry'

# text = File.open(__dir__ + '/input.txt').read
text = '3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5'

input_freeze = text.chomp.split(',').map(&:to_i).freeze

thrusters_calc = []

def run_int_code(input, signal, needle_position)
  until false
    if input[needle_position] == 99
      return [input, nil, needle_position]
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
      x = signal.shift
      input[input[needle_position + 1]] = x
      needle_position += 2
    elsif op_code == 4
      x = if !mode_1 || mode_1 == 0
            input[input[needle_position + 1]]
          else
            input[needle_position + 1]
          end
      puts x
      needle_position += 2
      return [input, x, needle_position]
    elsif op_code == 5
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
      if x != 0
        needle_position = y
      else
        needle_position += 3
      end
    elsif op_code == 6
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
      if x == 0
        needle_position = y
      else
        needle_position += 3
      end
    elsif op_code == 7
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
      if x < y
        input[input[needle_position + 3]] = 1
      else
        input[input[needle_position + 3]] = 0
      end
      needle_position += 4
    elsif op_code == 8
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
      if x == y
        input[input[needle_position + 3]] = 1
      else
        input[input[needle_position + 3]] = 0
      end
      needle_position += 4
    end
  end
end


signals = [9, 8, 7, 6, 5].freeze

needles = [0, 0, 0, 0, 0]
last_thrusters = [0, 0, 0, 0, 0]

values = signals.map { |signal| [signal] }
values[0].push(0)

inputs = [input_freeze.dup] * signals.length

done = false

while !done
  signals.length.times do |i|
    inputs[i], value, needle = run_int_code(inputs[i], values[i], needles[i])
    if !value
      done = true
      thrusters_calc.push(last_thrusters.last)
      break
    end

    needles[i] = needle
    last_thrusters[i] = value
    values[(i + 1) % values.length].append(value)
  end
end

puts thrusters_calc.max
