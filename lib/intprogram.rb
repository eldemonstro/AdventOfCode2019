# frozen_string_literal: true

require 'pry'

class Intprogram
  attr_accessor :program

  def initialize(program)
    @program = program
  end

  def run(inputs)
    intcode = program.dup
    needle = 0

    while(intcode[needle] != 99)
      posX = intcode[needle + 1]
      posY = intcode[needle + 2]
      posZ = intcode[needle + 3]

      case intcode[needle]
      when 1
        intcode[posZ] = intcode[posY].to_i + intcode[posX].to_i
        needle += 4
      when 2
        intcode[posZ] = intcode[posY].to_i * intcode[posX].to_i
        needle += 4
      end
    end

    intcode
  end

  def self.run(program, inputs = [])
    program = load_program(program) unless program.is_a?(Array)

    new(program).run(inputs)
  end

  def self.load_program(string_program)
    string_program.split(',').map(&:to_i)
  end
end
