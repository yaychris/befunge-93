module Befunge
  
  Directions  = [:up, :down, :left, :right]
  
  class Interpreter
    attr_reader :output
    
    PC = Struct.new(:row, :col, :direction)
    
    def initialize
      @stack    = Stack.new
      @program  = []
      @pc       = PC.new(0, 0, :right)
      @output   = ""
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
    
    def run
      loop do
        break if !step
      end
    end
    
    def restart
      @stack = Stack.new
      @pc.row, @pc.col = 0, 0
      self
    end
    
    
    private
    
    def process_cell
      cell = current_cell
      raise "Unknown command: #{cell} at (#{@pc.col}, #{@pc.row})" if !Commands.include? cell
      instance_eval(&Commands[cell])
      cell
    end
    
    def current_cell
      @program[@pc.row][@pc.col]
    end
    
    def tick_pc
      case @pc.direction
      when :right
        if @pc.col == @program[@pc.row].size - 1
          @pc.col = 0
        else
          @pc.col += 1
        end
      
      when :left
        if @pc.col == 0
          @pc.col = @program[@pc.row].size - 1
        else
          @pc.col -= 1
        end
      
      when :up
        if @pc.row == 0
          @pc.row = @program.size - 1
        else
          @pc.row -= 1
        end
      
      when :down
        if @pc.row == @program.size - 1
          @pc.row = 0
        else
          @pc.row += 1
        end
      end
      
      tick_pc if current_cell.nil?
    end
    
  end
end