require "rubygems"
require "befunge"
require "contest"

module Befunge
  class TestCase < Test::Unit::TestCase
    # here's a little DSL for making the tests neater

    def stack_data
      @befunge.stack.data
    end

    def program
      @befunge.instance_variable_get("@program")
    end

    def pc
      @befunge.pc
    end

    def parse(program = @program)
      @befunge.parse(program)
    end

    def run!(opts = {}) # we're banging because Test::Unit::TestCase defines #run
      @befunge.run(opts)
    end

    def step(n = 1)
      @befunge.step(n)
    end

    def output
      @befunge.output
    end

    def reset
      @befunge.reset
    end

    def pc_coord
      [pc.row, pc.col]
    end

    def int_input
      @befunge.instance_variable_get("@int_input")
    end

    def set_int_input(input)
      @befunge.instance_variable_set("@int_input", input)
    end

    def ascii_input
      @befunge.instance_variable_get("@ascii_input")
    end

    def set_ascii_input(input)
      @befunge.instance_variable_set("@ascii_input", input)
    end


    # so test/unit doesn't complain
    def default_test
    end
  end
end
