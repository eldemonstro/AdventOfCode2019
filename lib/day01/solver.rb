# frozen_string_literal: true

require_relative '../common'

module Day01
  class Solver < Common
    def part01
      masses.reduce(0) do |acc, value|
        acc + (value / 3).floor - 2
      end
    end

    def part02
      masses.reduce(0) do |acc, value|
        acc + recursive_fuel(value)
      end
    end

    private

    def masses
      @masses = input.map(&:to_i)
    end

    def recursive_fuel(mass)
      fuel = (mass / 3).floor - 2
      if fuel.positive?
        fuel + recursive_fuel(fuel)
      else
        0
      end
    end
  end
end
