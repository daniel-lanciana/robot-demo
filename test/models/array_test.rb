require 'minitest/autorun'
require './app/models/array'

describe Array, "Monkey patched Array object tests" do
  before do
    @array = [1, 2, 3]
  end

  describe "calling the next method" do
    it "returns the next element in the array" do
      assert_equal 2, @array.next_elem_infinite(1)
    end

    it "returns to the first element when reaching past the end of the array" do
      assert_equal 1, @array.next_elem_infinite(3)
    end

    it "returns nil if the argument element does not exist" do
      assert_nil @array.next_elem_infinite(100)
    end
  end

  describe "calling the prev method" do
    it "returns the previous element in the array" do
      assert_equal 2, @array.prev_elem_infinite(3)
    end

    it "returns to the last element when reaching before the start of the array" do
      assert_equal 3, @array.prev_elem_infinite(1)
    end

    it "returns nil if the argument element does not exist" do
      assert_nil @array.prev_elem_infinite(100)
    end
  end
end