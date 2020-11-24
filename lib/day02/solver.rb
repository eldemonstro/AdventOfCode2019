# frozen_string_literal: true

require_relative '../common'
require_relative '../intprogram'

module Day02
  class Solver < Common
    def part01
      program = Intprogram.load_program(input[0])
      program[1] = 12
      program[2] = 2

      Intprogram.run(program)[0]
    end

    def part02
      result = 0
      (0..99).each do |noun|
        (0..99).each do |verb|
          program = Intprogram.load_program(input[0])
          program[1] = noun
          program[2] = verb

          if Intprogram.run(program)[0] == 19690720
            result = 100 * noun + verb
          end
        end

        break if result != 0
      end

      result
    end
  end
end
