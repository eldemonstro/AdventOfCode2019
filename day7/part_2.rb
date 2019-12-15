# frozen_string_literal: true

text = File.open(__dir__ + '/input.txt').read

input_freeze = text.chomp.split(',').map(&:to_i).freeze

thrusters_calc = []

def run_int_code(input, signal, needle_position)
  loop do
    return [input, nil, needle_position] if input[needle_position] == 99

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
      x = signal[0]
      signal.shift
      input[input[needle_position + 1]] = x
      needle_position += 2
    elsif op_code == 4
      x = if !mode_1 || mode_1 == 0
            input[input[needle_position + 1]]
          else
            input[needle_position + 1]
          end
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
      input[input[needle_position + 3]] = if x < y
                                            1
                                          else
                                            0
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
      input[input[needle_position + 3]] = if x == y
                                            1
                                          else
                                            0
                                          end
      needle_position += 4
    end
  end
end

[9, 8, 7, 6, 5].permutation.each do |signals|
  needles = [0] * signals.length
  last_thrusters = [0] * signals.length

  values = signals.map { |signal| [signal] }
  values[0].append(0)

  inputs = [input_freeze.dup] * signals.length

  done = false

  until done
    signals.length.times do |i|
      inputs[i], value, needle = run_int_code(inputs[i].dup, values[i], needles[i])
      unless value
        done = true
        thrusters_calc.push(last_thrusters.last)
        break
      end

      needles[i] = needle
      last_thrusters[i] = value
      values[(i + 1) % values.length].append(value)
    end
  end
end

puts thrusters_calc.max
