# frozen_string_literal: true

require 'pry'

class NotImplemented < StandardError; end

class Common
  attr_writer :input

  def initialize(input_dir)
    @input_dir = input_dir
  end

  def load_file
    File.open(input_dir).read
  end

  def input
    @input ||= load_file.split("\n")
  end

  def part01
    raise NotImplemented
  end

  def part02
    raise NotImplemented
  end

  private

  attr_reader :input_dir
end
