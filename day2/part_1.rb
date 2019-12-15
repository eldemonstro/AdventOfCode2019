# frozen_string_literal: true

text = File.open(__dir__ + '/input.txt').read

input = text.chomp.split(',').map(&:to_i)

input[1] = 12
input[2] = 2

input.each_slice(4) do |op_code, pos_x, pos_y, pos_result|
  if op_code == 99
    break
  elsif op_code == 1
    x = input[pos_x]
    y = input[pos_y]
    input[pos_result] = x + y
  elsif op_code == 2
    x = input[pos_x]
    y = input[pos_y]
    input[pos_result] = x * y
  end
end

pp input
