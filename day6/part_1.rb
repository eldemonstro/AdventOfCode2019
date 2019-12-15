# frozen_string_literal: true

class Planet
  attr_reader :name
  attr_accessor :children, :parent

  def initialize(name)
    @name = name
    @children = []
  end

  def orbit_count(parent_count)
    parent_count = 0 if name == 'COM'

    children_sum = children.map do |child|
      child.orbit_count(parent_count + 1)
    end.sum

    parent_count + children_sum
  end
end

text = File.open(__dir__ + '/input.txt').read

input = text.split(/\s+/)

planets = {}

input.each do |orbit|
  planet_a, planet_b = orbit.split(')')
  planets[planet_a] = Planet.new(planet_a) unless planets[planet_a]
  planets[planet_b] = Planet.new(planet_b) unless planets[planet_b]

  planets[planet_b].parent = planets[planet_a]
  planets[planet_a].children.push(planets[planet_b])
end

pp planets['COM'].orbit_count(0)
