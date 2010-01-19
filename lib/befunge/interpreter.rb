module Befunge
  class ParseError < StandardError; end
  class UnknownCommandError < StandardError; end

  Directions  = [:up, :down, :left, :right]

  class Interpreter
    attr_reader :output, :pc, :stack, :ascii_input, :int_input

    PC = Struct.new(:row, :col, :direction)

    def initialize
      @stack       = Stack.new
      @program     = []
      @pc          = PC.new(0, 0, :right)
      @output      = ""
      @ascii_input = []
      @int_input   = []
    end

    def parse(input)
      if input.split(/\n/).compact.size > 25
        raise ParseError, "Program file must be 25 lines or less"
      end

      @program = input.map do |line|
        line.chomp!
        if line.size > 80
          raise ParseError, "Lines must be 80 characters or less"
        end
        line.scan(/./).ljust(80)
      end

      @program = @program.ljust(25, Array.new(80, nil))
    end

    def step(num = 1)
      num.times do
        return false if process_cell == "@"
        tick_pc
      end
      true
    end

    def run(options = {})
      @ascii_input  = options[:ascii_input] || []
      @int_input    = options[:int_input] || []

      loop do
        break unless step
      end
    end

    def reset
      @stack = Stack.new
      @pc = PC.new(0, 0, :right)
      @ascii_input = []
      @int_input = []
      @output = ""
      self
    end


    private

      def process_cell
        cell = current_cell

        unless Commands.include?(cell)
          raise UnknownCommandError, "Unknown command: #{cell} at (#{@pc.col}, #{@pc.row})"
        end

        instance_eval(&Commands[cell])
        cell
      end

      def current_cell
        @program[@pc.row][@pc.col]
      end

      def tick_pc
        case @pc.direction
        when :right then @pc.col += 1
        when :left  then @pc.col -= 1
        when :up    then @pc.row -= 1
        when :down  then @pc.row += 1
        end

        @pc.row %= 25
        @pc.col %= 80

        tick_pc if current_cell.nil?
      end
    end
end
