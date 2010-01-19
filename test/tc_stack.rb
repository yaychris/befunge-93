require "test_helper"

class TestBefungeStack < Befunge::TestCase
  setup do
    @stack = Befunge::Stack.new
  end

  should "be able to push" do
    @stack.push "1"
    assert_equal ["1"], @stack.data
  end

  should "be able to peek at the top" do
    assert_equal 0, @stack.top
    assert_equal [], @stack.data

    @stack.push "1"

    assert_equal "1", @stack.top
    assert_equal ["1"], @stack.data
  end

  should "return 0 when popping an empty stack" do
    assert_equal [], @stack.data
    assert_equal 0, @stack.pop
    assert_equal [], @stack.data
  end

  should "be able to pop" do
    @stack.push "1"
    assert_equal "1", @stack.pop
    assert_equal 0, @stack.pop
    assert_equal [], @stack.data
  end
end
