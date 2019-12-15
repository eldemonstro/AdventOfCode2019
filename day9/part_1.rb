text = File.open(__dir__ + '/input.txt').read

input_freeze = text.chomp.split(',').map(&:to_i).freeze

def run_int_code(program, inputs, needle_position, relative_base)
  while true
    if program[needle_position] == 99
      return [program, nil, needle_position, relative_base]
    end


    # ABCDE
    # DE = OP_CODE - 2 DIGITS
    # C  = First parameter mode
    # B  = Second parameter mode
    # A  = Third parameter mode
    parameter_hash = program[needle_position].digits.reverse
    op_code        = parameter_hash[-2, 2]&.join || parameter_hash[-1]
    mode_1         = parameter_hash[-3]
    mode_2         = parameter_hash[-4]
    mode_3         = parameter_hash[-5]

    op_code = op_code.to_i

    x_pos = if !mode_1 || mode_1 == 0
              program[needle_position + 1]
            elsif mode_1 == 1
              needle_position + 1
            elsif mode_1 == 2
              relative_base + program[needle_position + 1].to_i
            end
    y_pos = if !mode_2 || mode_2 == 0
              program[needle_position + 2]
            elsif mode_2 == 1
              needle_position + 2
            elsif mode_2 == 2
              relative_base + program[needle_position + 2].to_i
            end
    z_pos = if !mode_3 || mode_3 == 0
              program[needle_position + 3]
            elsif mode_3 == 1
              needle_position + 3
            elsif mode_3 == 2
              relative_base + program[needle_position + 3].to_i
            end

    x = program[x_pos.to_i] ||= 0
    y = program[y_pos.to_i] ||= 0

    if op_code == 1
      program[z_pos] = x + y
      needle_position += 4
    elsif op_code == 2
      program[z_pos] = x * y
      needle_position += 4
    elsif op_code == 3
      program[x_pos] = inputs.shift
      needle_position += 2
    elsif op_code == 4
      needle_position += 2
      return [program, x, needle_position, relative_base]
    elsif op_code == 5
      if x != 0
        needle_position = y
      else
        needle_position += 3
      end
    elsif op_code == 6
      if x == 0
        needle_position = y
      else
        needle_position += 3
      end
    elsif op_code == 7
      if x < y
        program[z_pos] = 1
      else
        program[z_pos] = 0
      end
      needle_position += 4
    elsif op_code == 8
      if x == y
        program[z_pos] = 1
      else
        program[z_pos] = 0
      end
      needle_position += 4
    elsif op_code == 9
      relative_base += x
      needle_position += 2
    end
  end
end

done = false
output_buffer = ''
program = input_freeze.dup
needle = 0
relative_base = 0

until done
  program, output, needle, relative_base = run_int_code(program.dup, [1], needle, relative_base)
  if !output
    done = true
    break
  end
  output_buffer.concat(output.to_s).concat(' ')
end

puts output_buffer
