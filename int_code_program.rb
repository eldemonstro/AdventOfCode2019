module IntCodeParser
  ADD = 1
  MULT = 2
  IN = 3
  OUT = 4
  IF = 5
  UNLESS = 6
  LESS = 7
  EQUALS = 8
  HALT = 99

  POSITION = 0
  IMMEDIATE = 1

  OP_CODES = {
    ADD => :add,
    MULT => :mult,
    IN => :in,
    OUT => :out,
    IF => :if,
    UNLESS => :unless,
    LESS => :less,
    EQUALS => :equals,
    HALT => :halt
  }

  PARAMETER_MODES = {
    POSITION => :position,
    IMMEDIATE => :immediate
  }

  def input_mode_analyzer(input_mode)
    parameter_hash = input_mode.digits.reverse
    op_code        = parse_op_code(parameter_hash[-2, 2]&.join || parameter_hash[-1])
    mode_1         = OP_CODES[parameter_hash[-3]]
    mode_2         = OP_CODES[parameter_hash[-4]]
    mode_3         = OP_CODES[parameter_hash[-5]]
    [op_code, mode_1, mode_2, mode_3]
  end

  def parse_op_code(op_code)
    OP_CODES[op_code.to_i]
  end
end

class Program
  include IntCodeParser

  attr_reader :program
  attr_accessor :needle

  def initialize(program)
    @program = program
    @needle = 0
  end

  def next
    op_code = input_mode_analyzer(program[needle])

    send(op_code[0], op_code.slice(1, op_code.length))
  end

  def in(params)

  end
end
