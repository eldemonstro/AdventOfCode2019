# frozen_string_literal: true

text = File.open(__dir__ + '/input.txt').read

input_freeze = text.chomp.split('').map(&:to_i).freeze

input = input_freeze.dup

WIDE = 25
TALL = 6

layers = []

until input.empty?
  layer = []
  WIDE.times do |_i|
    TALL.times do |_i|
      layer.push input.shift
    end
  end
  layers.push layer
end

total = layers.map do |layer|
  count = Hash.new(0)

  layer.each do |pixel|
    count[pixel] += 1
  end

  count
end

more_zeros = total.min_by { |x| x[0] }

pp more_zeros[1] * more_zeros[2]
