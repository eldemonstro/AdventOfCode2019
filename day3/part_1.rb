# frozen_string_literal: true

text = File.open(__dir__ + '/input.txt').read

wires = text.split(/\n/)

intersections = {}
paths = {}

def parse_wire(directions, paths, intersections)
  position = [0, 0]

  directions.each do |direction|
    intention, distance = direction.split('', 2)
    distance = distance.to_i

    until distance.zero?
      case intention
      when 'U'
        position[1] += 1
      when 'D'
        position[1] -= 1
      when 'L'
        position[0] -= 1
      when 'R'
        position[0] += 1
      end

      if paths["#{position[0]},#{position[1]}"]
        intersections[
          "#{position[0]},#{position[1]}"
        ] = position[0], position[1]
      else
        paths["#{position[0]},#{position[1]}"] = true
      end

      distance -= 1
    end
  end
end

wires.each do |wire|
  directions = wire.split(',')

  parse_wire(directions, paths, intersections)
end

result = intersections.values.inject(1 << 64) do |closest, intersection|
  distance = intersection[0].abs + intersection[1].abs
  closest > distance ? distance : closest
end

puts result
