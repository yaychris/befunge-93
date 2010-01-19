require "test_helper"

class TestBefungeCommands < Befunge::TestCase
  setup do
    @befunge = Befunge::Interpreter.new
  end

  test "addition" do
    parse "95+"
    step
    assert_equal [9], stack_data
    step
    assert_equal [5, 9], stack_data
    step
    assert_equal [14], stack_data
  end

  test "subtraction" do
    parse "59-"
    step 3
    assert_equal [-4], stack_data
  end

  test "multiplication" do
    parse "95*"
    step 3
    assert_equal [45], stack_data
  end

  test "division" do
    parse "93/"
    step 3
    assert_equal [3], stack_data
  end

  test "modulus" do
    parse "95%"
    step 3
    assert_equal [4], stack_data
  end

  test "negation" do
    parse "0!1!5!"
    step 2
    assert_equal [1], stack_data
    step 2
    assert_equal [0, 1], stack_data
    step 2
    assert_equal [0, 0, 1], stack_data
  end

  test "bridge pound" do
    parse "32#*+"
    step 3
    assert_equal [0,4], pc_coord
    step
    assert_equal [5], stack_data
  end

  test "dollar sign (pop)" do
    parse "5$"
    step 2
    assert_equal [], stack_data
  end

  test "underscore (if)" do
    parse "0_1_"
    step 2
    assert_equal :right, pc.direction
    step 2
    assert_equal :left, pc.direction
  end

  test "pipe (if)" do
    parse "v\n0\n|\n1\n|"
    step 3
    assert_equal :down, pc.direction
    step 2
    assert_equal :up, pc.direction
  end

  test "colon (duplication)" do
    parse "5:"
    step 2
    assert_equal [5, 5], stack_data
  end

  test "backslash (swap)" do
    parse "12\\"
    step 3
    assert_equal [1, 2], stack_data
  end

  test "backtick (greater than)" do
    parse "65`"
    step 3
    assert_equal [1], stack_data

    reset

    parse "25`"
    step 3
    assert_equal [0], stack_data
  end

  test "space (null command)" do
    parse "    22*"
    step 6
    assert_equal [2, 2], stack_data
    assert_equal [0, 6], pc_coord
  end

  test "at symbol (end)" do
    parse "22@+"
    step 3
    assert_equal [2, 2], stack_data
    step 3
    assert_equal [0, 2], pc_coord
  end

  test "double quote (string mode)" do
    parse "22*\"abc\"@"
    run!
    assert_equal [99, 98, 97, 4], stack_data
    assert_equal [0, 8], pc_coord
  end

  test "period (integer output)" do
    parse "99*.@"
    run!
    assert_equal "81", output
  end

  test "comma (ascii output)" do
    parse "99*9+7+,@"
    run!
    assert_equal "a", output
  end

  test "g (get)" do
    parse "40g +@"
    run!
    assert_equal [43], stack_data
  end

  test "p (put)" do
    parse "67*1+01p@\n "
    run!
    assert_equal "+", program[1][0]
  end

  test "ampersand (int input)" do
    parse "&&+@"
    set_int_input [4, 5]
    step
    assert_equal [4], stack_data
    step
    assert_equal [5, 4], stack_data
    step
    assert_equal [9], stack_data
    assert_equal [], int_input

    reset
    parse "&,@"
    run! :int_input => [65]
    assert_equal "A", output
  end

  def test_ascii_input_tilde
    #parse "~~@"

    #set_ascii_input ["A", "B"]
    #step
    #assert_equal [65], stack_data
    #step
    #assert_equal [66, 65], stack_data
    #assert_equal [], int_input

    #reset
    #parse "~.@"

    #run! :ascii_input => ["A"]
    #assert_equal "65", output
  end
end
