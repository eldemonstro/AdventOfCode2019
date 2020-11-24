# frozen_string_literal: true

require 'pry'

class NotImplemented < StandardError; end

class Common
  attr_writer :input

  def initialize(input_dir = '')
    @input_dir = load_file!(input_dir)
  end

  def part01
    raise NotImplemented
  end

  def part02
    raise NotImplemented
  end

  private

  attr_reader :input_dir

  def load_file!(file)
    return if File.exist?(file)

    "#{__dir__}/day#{self_day}/input.txt"
  end

  def load_file
    File.open(input_dir).read
  end

  def input
    @input ||= load_file.split("\n")
  end

  def self_day
    self.class.name.match(/(\d{2})/).captures.first
  end
end
