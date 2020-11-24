# frozen_string_literal: true

require_relative '../common'
require 'json'

module Day03
  class Solver < Common
    def part01
      map = get_intersections

      map.to_a.reduce(100000000) do |closest, node|
        node_pos = JSON.parse(node[0])
        distance = node_pos[0].abs + node_pos[1].abs
        distance < closest ? distance : closest
      end
    end

    def part02
      lines = parse_lines

      map = {}

      lines.each do |line|
        pos = [0, 0]
        step_number = 0
        line.each do |node|
          node[1].times do
            case node[0]
            when 'U'
              pos[1] += 1
            when 'D'
              pos[1] -= 1
            when 'L'
              pos[0] -= 1
            when 'R'
              pos[0] += 1
            end

            step_number += 1

            map[pos.to_s] ||= 0
            map[pos.to_s] += step_number
          end
        end
      end

      intersections = get_intersections.keys

      map.filter! { |key, value| intersections.include?(key) }

      map.to_a.reduce(100000000) do |closest, node|
        node[1] < closest ? node[1] : closest
      end
    end

    private

    def get_intersections
      lines = parse_lines

      map = {}

      lines.each do |line|
        pos = [0, 0]
        line.each do |node|
          node[1].times do
            case node[0]
            when 'U'
              pos[1] += 1
            when 'D'
              pos[1] -= 1
            when 'L'
              pos[0] -= 1
            when 'R'
              pos[0] += 1
            end

            map[pos.to_s] ||= 0
            map[pos.to_s] += 1
          end
        end
      end

      map.filter! { |key, value| value > 1 }
    end

    def parse_lines
      input.map do |line|
        line.split(',').map do |node|
          [node[0], node[1..].to_i]
        end
      end
    end
  end
end
