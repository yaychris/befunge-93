require "test/unit"
require "befunge"

module Befunge
  class TestCase < Test::Unit::TestCase
    def stack_data
      @befunge.stack.data
    end

    def program
      @befunge.instance_variable_get("@program")
    end

    def pc
      @befunge.pc
    end
    
    def parse(program)
      @befunge.parse(program)
    end
    
    def step(n = 1)
      @befunge.step(n)
    end
    
    def pc_coord
      [pc.row, pc.col]
    end

    def set_int_input(input)
      @befunge.instance_variable_set("@int_input", input)
    end

    def set_ascii_input(input)
      @befunge.instance_variable_set("@ascii_input", input)
    end

    # so test/unit doesn't complain
    def default_test
    end
  end
end
