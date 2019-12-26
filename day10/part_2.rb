# frozen_string_literal: true
require 'pry'

text = File.open(__dir__ + '/input.txt').read
line_length = 0
line_number = 0

class Asteroid
  attr_reader :x, :y

  attr_accessor :line_of_sight, :angle, :distance, :destroyed, :cool_text

  def initialize(x, y)
    @x = x.to_r
    @y = y.to_r
    @angle = nil
    @distance = nil
    @cool_text = nil
    @destroyed = false
    @line_of_sight = []
  end

  def to_s
    "x_cord: #{x}; y_cord: #{y}; line_of_sight: #{line_of_sight.count}"
  end

  def coordinates
    "#{x} #{y}"
  end

  def asteroid_text
    return cool_text if cool_text
    destroyed? ? '*' : '#'
  end

  def destroyed?
    destroyed
  end
end

class AsteroidList
  attr_accessor :asteroids, :line_number, :line_length

  def initialize(asteroids, line_number, line_length)
    @asteroids = asteroids
    @line_number = line_number
    @line_length = line_length
  end

  def distance(asteroid_a, asteroid_b)
    ((asteroid_b.x - asteroid_a.x) ** 2 + (asteroid_b.y - asteroid_a.y) ** 2) ** 1/2r
  end

  def look_for_line_of_sight
    asteroids.each do |asteroid|
      asteroids.each do |checkable|
        next if checkable.coordinates == asteroid.coordinates

        angle = (Math.atan2((checkable.y - asteroid.y), (checkable.x - asteroid.x)) * 180) / Math::PI

        asteroid.line_of_sight.push(angle.to_s)
      end

      asteroid.line_of_sight.uniq!
    end

    the_max_asteroid = asteroids.max_by { |x| x.line_of_sight.length }
    the_max_asteroid.cool_text = '0'

    done = false
    last_angle = -1
    index = 0
    max_angle = nil

    asteroids.each do |asteroid|
      angle = (Math.atan2((asteroid.y - the_max_asteroid.y), (asteroid.x - the_max_asteroid.x)) * 180) / Math::PI
      angle += 90
      angle += 360 if angle < 0

      distance = distance(asteroid, the_max_asteroid)

      asteroid.angle = angle
      asteroid.distance = distance
    end

    asteroids.sort_by! { |asteroid| [asteroid.angle, asteroid.distance] }

    until done
      index = 0 if index >= asteroids.count
      next index += 1 if asteroids[index].coordinates == the_max_asteroid.coordinates
      next index += 1 if asteroids[index].destroyed?
      next index += 1 if asteroids[index].angle == last_angle

      last_angle = asteroids[index].angle
      asteroids[index].destroyed = true

      index += 1

      if asteroids.reject { |asteroid| !asteroid.destroyed? }.count == 199
        puts asteroids[index]
        break
      end

      print_asteroids
    end
  end

  def print_asteroids
    sleep(0.05)
    outputbuffer = ''
    line_number.times do |line_index|
      line_length.times do |column_index|
        asteroid = asteroids.find { |a| a.y == line_index.to_r && a.x == column_index.to_r }
        outputbuffer += asteroid&.asteroid_text || '.'
      end
      outputbuffer += "\n"
    end

    puts outputbuffer

    puts '=============================='
  end

  def go
    look_for_line_of_sight
    self
  end
end

asteroids = []

line_number = text.lines.length

text.split(/\n/).each_with_index do |line, y_cord|
  line_length = line.length
  line.split('').each_with_index do |space, x_cord|
    asteroids.push(Asteroid.new(x_cord, y_cord)) if space == '#'
  end
end

list = AsteroidList.new(asteroids, line_number, line_length).go

puts list.asteroids.max_by { |x| x.line_of_sight.length }
