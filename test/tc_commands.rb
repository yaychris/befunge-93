require "test_helper"

class TestBefungeCommands < Befunge::TestCase
  def setup
    @befunge = Befunge::Interpreter.new
  end

  def test_addition
    parse "95+"

    step; assert_equal [9], stack_data
    step; assert_equal [5, 9], stack_data
    step; assert_equal [14], stack_data
  end

  def test_subtraction
    parse "59-"
    step 3
    assert_equal [-4], stack_data
  end

  def test_multiplication
    parse "95*"
    step 3
    assert_equal [45], stack_data
  end

  def test_division
    parse "93/"
    step 3
    assert_equal [3], stack_data
  end

  def test_modulus
    parse "95%"
    step 3
    assert_equal [4], stack_data
  end

  def test_negation
    parse "0!1!5!"

    step 2
    assert_equal [1], stack_data
    step 2
    assert_equal [0, 1], stack_data
    step 2
    assert_equal [0, 0, 1], stack_data
  end

  def test_bridge_pound
    parse "32#*+"

    step 3
    assert_equal [0,4], pc_coord
    step
    assert_equal [5], stack_data
  end

  def test_pop_dollar_sign
    parse "5$"

    step 2
    assert_equal [], stack_data
  end

  def test_if_underscore
    parse "0_1_"

    step 2
    assert_equal :right, pc.direction
    step 2
    assert_equal :left, pc.direction
  end

  def test_if_pipe
    program = "v\n0\n|\n1\n|"
    parse program

    step 3
    assert_equal :down, pc.direction

    step 2
    assert_equal :up, pc.direction
  end

  def test_duplication_colon
    parse "5:"

    step 2
    assert_equal [5, 5], stack_data
  end

  def test_swap_backslash
    parse "12\\"

    step 3
    assert_equal [1, 2], stack_data
  end

  def test_greater_than_backtick
    parse "65`"

    step 3
    assert_equal [1], stack_data

    @befunge.restart.parse "25`"
    step 3
    assert_equal [0], stack_data
  end

  def test_null_command_space
    parse "    22*"

    step 6
    assert_equal [2, 2], stack_data
    assert_equal [0, 6], pc_coord
  end

  def test_end_at_symbol
    parse "22@+"

    step 3
    assert_equal [2, 2], stack_data
    step 3
    assert_equal [0, 2], pc_coord
  end

  def test_string_mode_double_quote
    parse "22*\"abc\"@"

    @befunge.run
    assert_equal [99, 98, 97, 4], stack_data
    assert_equal [0, 8], pc_coord
  end

  def test_integer_output_period
    parse "99*.@"

    @befunge.run
    assert_equal "81", @befunge.output
  end

  def test_ascii_output_comma
    parse "99*9+7+,@"

    @befunge.run
    assert_equal "a", @befunge.output
  end

  def test_get_g
    parse "40g +@"

    @befunge.run
    assert_equal [43], stack_data
  end

  def test_put_p
    parse "67*1+01p@\n "

    @befunge.run
    assert_equal "+", program[1][0]
  end

  def test_int_input_ampersand
    parse "&&+@"

    set_int_input [4, 5]
    step
    assert_equal [4], stack_data
    step
    assert_equal [5, 4], stack_data
    step
    assert_equal [9], stack_data
    assert_equal [], @befunge.int_input

    @befunge.restart
    parse "&,@"

    @befunge.run :int_input => [65]
    assert_equal "A", @befunge.output
  end

  def test_ascii_input_tilde
    #parse "~~@"

    #set_ascii_input ["A", "B"]
    #step
    #assert_equal [65], stack_data
    #step
    #assert_equal [66, 65], stack_data
    #assert_equal [], @befunge.int_input

    #@befunge.restart
    #parse "~.@"

    #@befunge.run :ascii_input => ["A"]
    #assert_equal "65", @befunge.output
  end
end