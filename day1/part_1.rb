# frozen_string_literal: true

text = File.open(__dir__ + '/input.txt').read

result = text.split(/\n/).reduce(0) do |sum, fuel|
  sum + (fuel.to_i / 3) - 2
end

puts result

["", "1"].reject(&:empty?)
