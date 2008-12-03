require "test/unit"

require "befunge"
require "test_helper"


####
# Add some test-only accessors
####
module Befunge
  class Interpreter
    attr_accessor :stack, :program, :pc
  end
  
  class Stack
    attr_accessor :data
  end
end


class TestBefungeInterpreter < Test::Unit::TestCase
  
  include BefungeTestHelper
  
  def setup
    @befunge = Befunge::Interpreter.new
    
    @simple_input = <<END_INPUT
99*76*+
24+42+*
END_INPUT
    
    @complex_input = <<END_COMPLEX
100p110p 88*:*8*2- v                                       v       <
>                  > : 88*:*8* / 00g* 25*::*8*\4*+ / 58* + >".",1-:|
  v                                                      ,*52,"*"$ <
  > :: 88*:*8* % 10g* 88*:*8*88*-1+ * \ 88*:*8* / 00g* 25*::**2*3- * - v
  v                                                        / -2*8*:*88 <
  > \: 88*:*8* / 00g* 88*:*8*88*-1+ * \ 88*:*8* % 10g* 25*::**2*3- * + v
  v                                                        / -2*8*:*88 <
          > 100p       v         > 110p       v
  > : 0 ` |            > \ : 0 ` |            > \ 88*:*8* * + v
          > 01-00p 0\- ^         > 01-10p 0\- ^
^                                                             <
END_COMPLEX
  end
  
  
  ####
  # Test parser
  ####
  def test_empty_playfield_before_parsing
    assert_equal(0, @befunge.program.size)
  end
  
  
  def test_full_size_playfield_after_parsing
    parse(@simple_input)
    
    assert_equal(25, @befunge.program.size)
    @befunge.program.each { |row| assert_equal(80, row.size) }
  end
  
  
  def test_parse_simple_input
    parse(@simple_input)
    
    assert_equal(["9", "9", "*", "7", "6", "*", "+"].join, @befunge.program[0].join)
    assert_equal(["2", "4", "+", "4", "2", "+", "*"].join, @befunge.program[1].join)
  end
  
  def test_parse_complex_input
    parse(@complex_input)
    
    assert_equal(25, @befunge.program.size)
    @befunge.program.each { |row| assert_equal(80, row.size) }
    
    @complex_input.split(/\n/).each_with_index do |row, i|
      assert_equal(row, @befunge.program[i].join)
    end
  end
  
  
  def test_raise_on_invalid_input
    assert_raise(RuntimeError) { parse("1" * 81) }
    assert_raise(RuntimeError) { parse("1\n" * 26) }
  end
  
  
  ####
  # Test input
  ####
  def test_assigns_empty_ascii_input
    assert_equal([], @befunge.ascii_input)
  end
  
  def test_assigns_empty_int_input
    assert_equal([], @befunge.int_input)
  end
  
  def test_accepts_input_to_run
    parse("@")
    
    @befunge.run :ascii_input => [">", "^", "<", "v"], :int_input => [1, 2, 3, 4]
    
    assert_equal([">", "^", "<", "v"], @befunge.ascii_input)
    assert_equal([1, 2, 3, 4], @befunge.int_input)
  end
  
  
  ####
  # Test PC movement
  ####
  def test_step_pc_right
    parse(@simple_input)
    pc.direction = :right
    
    step
    assert_equal([0, 1], pc_coord)
    
    step(6)
    assert_equal([0, 0], pc_coord)
  end
  
  
  def test_step_pc_left
    parse(@simple_input)
    pc.direction = :left
    
    step
    assert_equal([0, 6], pc_coord)
    
    step(6)
    assert_equal([0, 0], pc_coord)
  end
  
  
  def test_step_pc_up
    parse(@simple_input)
    pc.direction = :up
    
    step
    assert_equal([1, 0], pc_coord)
    
    step
    assert_equal([0, 0], pc_coord)
  end
  
  
  def test_step_pc_down
    parse(@simple_input)
    pc.direction = :down
    
    step
    assert_equal([1, 0], pc_coord)
    
    step
    assert_equal([0, 0], pc_coord)
  end
  
  
  def test_run
    parse("23*@55+")
    
    @befunge.run
    assert_equal([6], stack_data)
    assert_equal([0, 3], pc_coord)
  end
  
  
  def test_restart
    parse("52*")
    
    step(3)
    @befunge.restart
    assert_equal([], stack_data)
    assert_equal([0, 0], pc_coord)
  end
  
end