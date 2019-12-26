# frozen_string_literal: true
require 'pry'

text = File.open(__dir__ + '/input.txt').read

input_freeze = text.chomp.split(',').map(&:to_i).freeze

class Panel
  attr_accessor :x, :y, :color, :painted

  def initialize(x, y)
    @x = x
    @y = y
    @color = 0
    @painted = false
  end

  def painted?
    painted
  end

  def to_s
    "x: #{x}, y: #{y}, color: #{color == 0 ? 'black' : 'white'}, painted: #{painted}"
  end
end

def run_int_code(program, inputs, needle_position, relative_base)
  loop do
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
      program[z_pos] = if x < y
                         1
                       else
                         0
                       end
      needle_position += 4
    elsif op_code == 8
      program[z_pos] = if x == y
                         1
                       else
                         0
                       end
      needle_position += 4
    elsif op_code == 9
      relative_base += x
      needle_position += 2
    end
  end
end

def print_panels(panels, position, direction)
  output_buffer = ''
  min_x = -22
  min_y = -29
  max_x = 31
  max_y = 27

  (min_y..max_y).each do |line|
    (min_x..max_x).each do |column|
      if position[0] == column && position[1] == line
        output_buffer += if direction == 0
                           'v'
                         elsif direction == 1
                           '<'
                         elsif direction == 2
                           '^'
                         elsif direction == 3
                           '>'
                         end
        next
      end

      found_panel = panels.find { |panel| panel.y == line && panel.x == column }

      if found_panel
        output_buffer += found_panel.color == 0 ? '█' : '░'
      else
        output_buffer += '█'
      end
    end

    output_buffer += "\n"
  end

  puts output_buffer
  puts '=================================================================='
end

done = false
program = input_freeze.dup
needle = 0
relative_base = 0
position = [0, 0]
panels = []

#directions are 0-up, 1-left, 2-down, 3-right
direction = 0

until done
  panel = panels.find { |panel| panel.x == position[0] && panel.y == position[1] }

  if !panel
    panel = Panel.new(position[0], position[1])
    panels.push(panel)
  end

  inputs = [panel.color]

  program, paint_color, needle, relative_base = run_int_code(program.dup, inputs, needle, relative_base)
  program, turn_direction, needle, relative_base = run_int_code(program.dup, inputs, needle, relative_base)

  unless paint_color || turn_direction
    done = true
    break
  end

  if paint_color != panel.color
    panel.color = paint_color
    panel.painted = true
  end

  # print_panels(panels.dup, position, direction)

  direction += turn_direction == 0 ? +1 : -1

  if direction < 0
    direction = 3
  elsif direction > 3
    direction = 0
  end

  case direction
  when 0
    position[1] += 1
  when 1
    position[0] -= 1
  when 2
    position[1] -= 1
  when 3
    position[0] += 1
  end

end

puts panels.count
