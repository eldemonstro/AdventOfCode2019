# frozen_string_literal: true

text = "<x=-19, y=-4, z=2>
<x=-9, y=8, z=-16>
<x=-4, y=5, z=-11>
<x=1, y=9, z=-13>"

Moon = Struct.new(:x, :y, :z, :vel_x, :vel_y, :vel_z, :name) do
  def inspect
    "#{x}#{y}#{z}#{vel_x}#{vel_y}#{vel_z}"
  end
end

def parse_moon(moon_input, moon_index)
  coords = /\<x\=(-{0,1}\d{1,}).+y\=(-{0,1}\d{1,}).+z\=(-{0,1}\d{1,})/.match(moon_input)

  Moon.new(coords[1].to_i, coords[2].to_i, coords[3].to_i, 0, 0, 0, "moon_#{moon_index}")
end

def calc_vel(a, b)
  b <=> a
end

def print_moons(moons)
  moons.each do |moon|
    x = moon.x
    y = moon.y
    z = moon.z
    vel_z = moon.vel_z
    vel_y = moon.vel_y
    vel_x = moon.vel_x
    name = moon.name
    puts "pos=<x=#{x >= 0 ? " #{x}" : x},y=#{y >= 0 ? " #{y}" : y},z=#{z >= 0 ? " #{z}" : z}>, vel=<x=#{vel_x >= 0 ? " #{vel_x}" : vel_x},y=#{vel_y >= 0 ? " #{vel_y}" : vel_y},z=#{vel_z >= 0 ? " #{vel_z}" : vel_z}>; #{name}"
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

# Solution

step_index = 1

trap "SIGINT" do
  puts "Exiting #{step_index}" 
  exit 130
end

moons = text.split(/\n/).map.with_index do |line, index|
  parse_moon(line, index)
end

frozen_moons = text.split(/\n/).map.with_index do |line, index|
  parse_moon(line, index)
end.freeze

print_moons(moons)


def simulate(positions, velocities)
  pairs = [[0, 1], [0, 2], [0, 3], [1, 2], [1, 3], [2, 3]].freeze

  original_positions = positions.dup
  original_velocities = velocities.dup

  step_index = 1

  while true
    pairs.each do |pair|
      velocities[pair[0]] += positions[pair[1]] <=> positions[pair[0]]
      velocities[pair[1]] += positions[pair[0]] <=> positions[pair[1]]
    end

    velocities.each.with_index do |vel, i|
      positions[i] += vel
    end

    break unless (positions != original_positions || velocities != original_velocities)

    step_index += 1
  end

  step_index
end

x_sim = simulate(moons.map(&:x), moons.map(&:vel_x))
y_sim = simulate(moons.map(&:y), moons.map(&:vel_y))
z_sim = simulate(moons.map(&:z), moons.map(&:vel_z))

puts x_sim.lcm(y_sim.lcm(z_sim))
