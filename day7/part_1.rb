# frozen_string_literal: true

text = File.open(__dir__ + '/input.txt').read

input_freeze = text.chomp.split(',').map(&:to_i).freeze

thrusters_calc = []

43_210.digits.permutation.each do |signals|
  last_thurst = 0

  signals.each do |signal|
    input = input_freeze.dup
    halt = false
    needle_position = 0

    first_input = false
    thruster = 0

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
        x = if !first_input
              first_input = true
              signal
            else
              last_thurst
            end
        input[input[needle_position + 1]] = x
        needle_position += 2
      elsif op_code == 4
        x = input[input[needle_position + 1]]
        thruster += x
        needle_position += 2
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

    last_thurst = thruster
  end

  thrusters_calc << last_thurst
end

puts thrusters_calc.max
