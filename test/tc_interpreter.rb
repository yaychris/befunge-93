require "test_helper"

class TestBefungeInterpreter < Befunge::TestCase
  setup do
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


  context "when parsing" do
    should "have an empty playfield before parsing" do
      assert_equal 0, program.size
    end

    should "have a full playfield after parsing" do
      parse @simple_input

      assert_equal 25, program.size
      program.each { |row| assert_equal 80, row.size }
    end

    should "successfully parse simple input" do
      parse @simple_input

      assert_equal ["9", "9", "*", "7", "6", "*", "+"].join, program[0].join
      assert_equal ["2", "4", "+", "4", "2", "+", "*"].join, program[1].join
    end

    should "successfully parse complex input" do
      parse @complex_input

      assert_equal 25, program.size
      program.each { |row| assert_equal(80, row.size) }

      @complex_input.split(/\n/).each_with_index do |row, i|
        assert_equal row, program[i].join
      end
    end

    should "raise an exception on improperly sized playfield" do
      assert_raise(Befunge::ParseError) { parse("1" * 81) }
      assert_raise(Befunge::ParseError) { parse("1\n" * 26) }
    end
  end


  context "input" do
    should "assign empty ASCII input by defualt" do
      assert_equal [], @befunge.ascii_input
    end

    should "assign empty int input by default" do
      assert_equal [], @befunge.int_input
    end

    should "accept input when calling #run" do
      parse "@"
      run! :ascii_input => [">", "^", "<", "v"], :int_input => [1, 2, 3, 4]

      assert_equal [">", "^", "<", "v"], ascii_input
      assert_equal [1, 2, 3, 4], int_input
    end
  end


  context "program counter" do
    should "be able to move right" do
      parse @simple_input
      pc.direction = :right
      step
      assert_equal [0, 1], pc_coord
      step 6
      assert_equal [0, 0], pc_coord
    end

    should "be able to move left" do
      parse @simple_input
      pc.direction = :left
      step
      assert_equal [0, 6], pc_coord
      step 6
      assert_equal [0, 0], pc_coord
    end

    should "be able to move up" do
      parse @simple_input
      pc.direction = :up
      step
      assert_equal [1, 0], pc_coord
      step
      assert_equal [0, 0], pc_coord
    end

    should "be able to move down" do
      parse @simple_input
      pc.direction = :down
      step
      assert_equal [1, 0], pc_coord
      step
      assert_equal [0, 0], pc_coord
    end
  end


  context "when running" do
    should "execute correctly" do
      parse "23*@55+"
      run!

      assert_equal [6], stack_data
      assert_equal [0, 3], pc_coord
    end

    should "raise an exception if unknown command" do
      assert_raise(Befunge::UnknownCommandError) do
        parse("]")
        step
      end
    end
  end

  should "be able to reset" do
    parse "52*"
    step 3
    reset
    assert_equal [], stack_data
    assert_equal [0, 0], pc_coord
  end
end
