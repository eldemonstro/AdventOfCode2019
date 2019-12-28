# frozen_string_literal: true

text = File.open(__dir__ + '/input.txt').read

class Moon
  attr_accessor :x, :y, :z, :vel_x, :vel_y, :vel_z, :name

  def initialize(x, y, z, name)
    @x = x.to_i
    @y = y.to_i
    @z = z.to_i
    @vel_x = 0
    @vel_y = 0
    @vel_z = 0
    @name = name
  end

  def to_s
    "pos=<x=#{x >= 0 ? " #{x}" : x},y=#{y >= 0 ? " #{y}" : y},z=#{z >= 0 ? " #{z}" : z}>, vel=<x=#{vel_x >= 0 ? " #{vel_x}" : vel_x},y=#{vel_y >= 0 ? " #{vel_y}" : vel_y},z=#{vel_z >= 0 ? " #{vel_z}" : vel_z}>; #{name}"
  end

  def pot
    z.abs + y.abs + x.abs
  end

  def pot_s
    "pot: #{x} + #{y} + #{z} = #{pot}"
  end

  def kin
    vel_x.abs + vel_y.abs + vel_z.abs
  end

  def kin_s
    "kin: #{vel_x} + #{vel_y} + #{vel_z} = #{kin}"
  end

  def total
    pot * kin
  end

  def total_s
    "total: #{pot} * #{kin} = #{total}"
  end
end

def parse_moon(moon_input, moon_index)
  coords = /\<x\=(-{0,1}\d{1,}).+y\=(-{0,1}\d{1,}).+z\=(-{0,1}\d{1,})/.match(moon_input)

  Moon.new(coords[1], coords[2], coords[3], "moon_#{moon_index}")
end

def calc_vel(a, b)
  if a == b
    0
  elsif a < b
    +1
  else
    -1
  end
end

def print_moons(moons)
  moons.each do |moon|
    puts moon
  end
  puts
end

def print_energy(moons)
  output_buffer = ""

  total = moons.map do |moon|
    output_buffer += "#{moon.pot_s}; #{moon.kin_s}; #{moon.total_s}\n"
    moon.total
  end

  output_buffer += "Sum of total energy: #{total.join(' + ')} = #{total.sum}"
  puts output_buffer
end

moons = text.split(/\n/).map.with_index do |line, index|
  parse_moon(line, index)
end

print_moons(moons)

1000.times do
  (0..(moons.count - 2)).each do |moon_index|
    ((moon_index + 1)..(moons.count - 1)).each do |other_moon_index|

      moons[moon_index].vel_x += calc_vel(moons[moon_index].x, moons[other_moon_index].x)
      moons[moon_index].vel_y += calc_vel(moons[moon_index].y, moons[other_moon_index].y)
      moons[moon_index].vel_z += calc_vel(moons[moon_index].z, moons[other_moon_index].z)

      moons[other_moon_index].vel_x += calc_vel(moons[other_moon_index].x, moons[moon_index].x)
      moons[other_moon_index].vel_y += calc_vel(moons[other_moon_index].y, moons[moon_index].y)
      moons[other_moon_index].vel_z += calc_vel(moons[other_moon_index].z, moons[moon_index].z)
    end
  end

  moons.each do |moon|
    moon.x += moon.vel_x
    moon.y += moon.vel_y
    moon.z += moon.vel_z
  end
end

print_moons(moons)

print_energy(moons)
