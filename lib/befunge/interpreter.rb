module Befunge
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
      raise "Parse Error" if input.split(/\n/).compact.size > 25

      @program = input.map do |line|
        line.chomp!
        raise "Parse Error" if line.size > 80
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
        break if !step
      end
    end

    def restart
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
        raise "Unknown command: #{cell} at (#{@pc.col}, #{@pc.row})" unless Commands.include?(cell)
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
