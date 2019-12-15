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

total = layers.inject(Array.new(WIDE * TALL, 2)) do |image, layer|
  index = 0

  layer.each do |pixel|
    if image[index] == 2
      image[index] = pixel
    end

    index += 1
  end

  image
end

TALL.times do
  buffer = ""
  WIDE.times do
    value = total.shift
    buffer.concat(value == 0 ? " " : "|")
  end
  pp buffer
end
