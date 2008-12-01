module Befunge
  class Stack
    def initialize
      @data = []
    end
  
    def push(val)
      @data.unshift(val)
    end
  
    def top
      @data.first || 0
    end
  
    def pop
      @data.shift || 0
    end
  
    def pop_two
      [pop, pop]
    end
  end
end