# frozen_string_literal: true

text = File.open(__dir__ + '/input.txt').read

result = text.split(/\n/).reduce(0) do |sum, mass|
  fuel_requirement = (mass.to_i / 3) - 2
  until fuel_requirement.zero?
    sum += fuel_requirement
    fuel_requirement = (fuel_requirement / 3) - 2
    break if fuel_requirement < 1
  end
  sum
end

puts result
