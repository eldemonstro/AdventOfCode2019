# frozen_string_literal: true

text = File.open(__dir__ + '/input.txt').read

wires = text.split(/\n/)

paths = {}
fewest_steps = []

wires.each_with_index do |wire, index|
  directions = wire.split(',')
  position = [0, 0]
  step_count = 0

  directions.each do |direction|
    intention, distance = direction.split('', 2)
    distance = distance.to_i

    until distance == 0
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

      if paths["#{position[0]},#{position[1]},#{index - 1}"]
        fewest_steps << paths["#{position[0]},#{position[1]},#{index - 1}"][:step_count] + step_count
      end

      paths["#{position[0]},#{position[1]},#{index}"] = { step_count: step_count }

      distance -= 1
      step_count += 1
    end
  end
end

# + 2 comes from the first step (from pos 0, 0)
pp fewest_steps.min + 2
