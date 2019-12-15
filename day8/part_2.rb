# frozen_string_literal: true

text = File.open(__dir__ + '/input.txt').read

input_freeze = text.chomp.split('').map(&:to_i).freeze

input = input_freeze.dup

WIDE = 25
TALL = 6

layers = []

until input.empty?
  layer = []
  WIDE.times do
    TALL.times do
      layer.push input.shift
    end
  end
  layers.push layer
end

total = layers.each_with_object(Array.new(WIDE * TALL, 2)) do |layer, image|
  index = 0

  layer.each do |pixel|
    image[index] = pixel if image[index] == 2

    index += 1
  end
end

TALL.times do
  buffer = ''
  WIDE.times do
    value = total.shift
    buffer.concat(value == 0 ? ' ' : '|')
  end
  pp buffer
end
