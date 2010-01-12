require "test_helper"

class TestBefungeStack < Befunge::TestCase
  def setup
    @stack = Befunge::Stack.new
  end

  def test_push
    @stack.push "1"
    assert_equal ["1"], @stack.data
  end

  def test_top
    assert_equal 0, @stack.top
    assert_equal [], @stack.data

    @stack.push "1"
    assert_equal "1", @stack.top
    assert_equal ["1"], @stack.data
  end

  def test_pop_empty_stack
    assert_equal [], @stack.data
    assert_equal 0, @stack.pop
    assert_equal [], @stack.data
  end

  def test_pop_stack
    @stack.push "1"
    assert_equal "1", @stack.pop
    assert_equal 0, @stack.pop
    assert_equal [], @stack.data
  end

  def test_pop_two
    @stack.push "1"
    assert_equal ["1", 0], @stack.pop_two
    assert_equal [], @stack.data

    @stack.push "1"
    @stack.push "2"
    assert_equal ["2", "1"], @stack.pop_two
    assert_equal [], @stack.data
  end
end