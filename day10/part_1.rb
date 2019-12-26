# frozen_string_literal: true

text = File.open(__dir__ + '/input.txt').read

class Asteroid
  attr_reader :x, :y

  attr_accessor :line_of_sight

  def initialize(x, y)
    @x = x.to_r
    @y = y.to_r
    @line_of_sight = []
  end

  def to_s
    "x_cord: #{x}; y_cord: #{y}; line_of_sight: #{line_of_sight.count}"
  end

  def coordinates
    "#{x} #{y}"
  end
end

class AsteroidList
  attr_accessor :asteroids

  def initialize(asteroids)
    @asteroids = asteroids
  end

  def distance(asteroid_a, asteroid_b)
    ((asteroid_b.x - asteroid_a.x) ** 2 + (asteroid_b.y - asteroid_a.y) ** 2) ** 1/2r
  end

  def look_for_line_of_sight
    asteroids.each do |asteroid|
      asteroids.each do |checkable|
        next if checkable.coordinates == asteroid.coordinates

        angle = (Math.atan2((checkable.y - asteroid.y), (checkable.x - asteroid.x)) * 180) / Math::PI
        angle += 360 if angle < 0

        asteroid.line_of_sight.push(angle.to_s)
      end

      asteroid.line_of_sight.uniq!
    end
  end

  def go
    look_for_line_of_sight
    self
  end
end

asteroids = []

text.split(/\n/).each_with_index do |line, y_cord|
  line.split('').each_with_index do |space, x_cord|
    asteroids.push(Asteroid.new(x_cord, y_cord)) if space == '#'
  end
end

list = AsteroidList.new(asteroids).go

puts list.asteroids.max_by { |x| x.line_of_sight.length }
