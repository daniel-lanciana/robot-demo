require 'test_helper'
require 'minitest/autorun'
require './app/models/table'

describe Table, "Table module tests" do
  it "returns the table length" do
    assert_equal 5, Table.length
  end
end