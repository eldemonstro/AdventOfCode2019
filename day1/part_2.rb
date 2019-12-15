# frozen_string_literal: true

text = File.open(__dir__ + '/input.txt').read

result = text.split(/\n/).reduce(0) do |sum, mass|
  fuel_requirement = (mass.to_i / 3) - 2
  other_sum = 0
  until fuel_requirement == 0
    other_sum += fuel_requirement
    fuel_requirement = (fuel_requirement / 3) - 2
    break if fuel_requirement < 1
  end
  sum += other_sum
end

puts result
