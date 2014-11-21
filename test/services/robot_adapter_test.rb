require 'test_helper'
require 'minitest/autorun'
require './app/services/robot_adapter'

# Unit tests to ensure the raw input is validated and adapted to the relevant Robot model calls.
describe RobotAdapter, "Robot adapter test" do
  MOCK_REPORT = "mock report"

  before do
    @adapter = RobotAdapter.new
    @table = MiniTest::Mock.new
    @adapter.table = @table
  end

  describe "given raw input commands" do
    it "first argument of PLACE must be an integer" do
      assert_equal AppConfig.msg_place_args, @adapter.input("PLACE FOO,1,NORTH")
    end

    it "second argument of PLACE must be an integer" do
      assert_equal AppConfig.msg_place_args, @adapter.input("PLACE 1,FOO,NORTH")
    end

    it "third argument of PLACE must be either of NORTH/SOUTH/EAST/WEST" do
      assert_equal AppConfig.msg_place_args, @adapter.input("PLACE 1,2,FOO")
    end

    it "ignores bad input" do
      assert_equal AppConfig.msg_place_args, @adapter.input("FOO BAR")
    end

    it "ignores missing input" do
      assert_equal AppConfig.msg_place_args, @adapter.input("")
    end

    it "calls the PLACE method" do
      @table.expect :place, nil, [123, 456, :north]
      @adapter.input "PLACE 123,456,NORTH"
      @table.verify
    end

    it "calls the MOVE method" do
      @table.expect :move, nil
      @adapter.input "MOVE"
      @table.verify
    end

    it "calls the LEFT method" do
      @table.expect :left, nil
      @adapter.input "LEFT"
      @table.verify
    end

    it "calls the RIGHT method" do
      @table.expect :right, nil
      @adapter.input "RIGHT"
      @table.verify
    end

    it "calls the REPORT method" do
      @table.expect :report, MOCK_REPORT
      report = @adapter.input "REPORT"
      assert_equal MOCK_REPORT, report
    end

    it "is case insensitive" do
      @table.expect :move, nil
      @adapter.input "mOvE"
      @table.verify
    end
  end
end