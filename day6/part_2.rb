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

require 'pry'

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

planet_a = planets['YOU'].parent
planet_b = planets['SAN'].parent
road_a = []
road_b = []

until planet_a.nil?
  road_a << planet_a.name

  planet_a = planet_a.parent
end

loop do
  road_b << planet_b.name

  break if road_a.include?(planet_b.name)

  planet_b = planet_b.parent
end

road_a.slice! road_a.index(road_b.last), road_a.length

# - 1 comes from the last step that we dont need to do because we are at the
# orbit
pp road_a.count + road_b.count - 1
