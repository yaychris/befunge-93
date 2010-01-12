require "test_helper"

class TestLjustArrayMethod < Test::Unit::TestCase
  def setup
    @arr = [5]
  end

  def test_length_too_small_to_ljust
    assert_equal [5], @arr.ljust(1)
  end

  def test_default_pad_behavior
    assert_equal [5, nil], @arr.ljust(2)
    assert_equal [5, nil, nil], @arr.ljust(3)
  end

  def test_pad_with_an_object
    obj = Object.new
    assert_equal [5, obj], @arr.ljust(2, obj)
  end

  def test_does_not_modify_original_object
    assert_equal [5, nil], @arr.ljust(2)
    assert_equal [5], @arr
  end
end