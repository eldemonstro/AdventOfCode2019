# frozen_string_literal: true
require 'pry'

text = File.open(__dir__ + '/input.txt').read

input_freeze = text.chomp.split(',').map(&:to_i).freeze

class Tile
  attr_accessor :x, :y, :tile_id

  def initialize(x, y, tile_id)
    @x = x
    @y = y
    @tile_id = tile_id
  end

  def to_s
    case tile_id
    when 0
      " "
    when 1
      '█'
    when 2
      'B'
    when 3
      '-'
    when 4
      'O'
    end
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

def print_tiles(tiles, score)
  output_buffer = ''
  min_x = tiles.min_by { |tile| tile.x }.x
  min_y = tiles.min_by { |tile| tile.y }.y
  max_x = tiles.max_by { |tile| tile.x }.x
  max_y = tiles.max_by { |tile| tile.y }.y

  output_buffer += "----------\n"
  output_buffer += score.to_s + "\n"
  output_buffer += "----------\n"

  (min_y..max_y).each do |line|
    (min_x..max_x).each do |column|
      found_tile = tiles.find { |tile| tile.y == line && tile.x == column }

      if found_tile
        output_buffer += found_tile.to_s
      else
        output_buffer += ' '
      end
    end

    output_buffer += "\n"
  end

  puts output_buffer
  puts '=================================================================='
end

done = false
program = input_freeze.dup
program[0] = 2
needle = 0
relative_base = 0
max_score = 0
tiles = []
print_index = 0

until done
  ball = tiles.find { |tile| tile.tile_id == 4 }
  paddle = tiles.find { |tile| tile.tile_id == 3 }
  inputs = [ball&.x <=> paddle&.x]


  program, x_pos, needle, relative_base = run_int_code(program.dup, inputs, needle, relative_base)

  ball = tiles.find { |tile| tile.tile_id == '4'}
  paddle = tiles.find { |tile| tile.tile_id == '3' }
  inputs = [ball&.x <=> paddle&.x]

  program, y_pos, needle, relative_base = run_int_code(program.dup, inputs, needle, relative_base)

  ball = tiles.find { |tile| tile.tile_id == '4'}
  paddle = tiles.find { |tile| tile.tile_id == '3' }
  inputs = [ball&.x <=> paddle&.x]


  program, score_or_tile_id, needle, relative_base = run_int_code(program.dup, inputs, needle, relative_base)

  if x_pos == -1 && y_pos == 0
    max_score = score_or_tile_id
  else
    tile_found = tiles.find { |tile| tile.x == x_pos && tile.y == y_pos }
    if tile_found
      tile_found.tile_id = score_or_tile_id
    else
      tiles.push Tile.new(x_pos, y_pos, score_or_tile_id)
    end
  end

  if print_index % 4 == 0
    print_tiles(tiles, max_score)
  end

  print_index += 1

  unless x_pos || y_pos || score_or_tile_id
    done = true
    break
  end
end

puts max_score
