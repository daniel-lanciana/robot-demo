require 'test_helper'
require 'minitest/autorun'
require './app/services/demo_processor'

# Unit tests to ensure the raw input is validated and adapted to the relevant Robot model calls.
describe DemoProcessor, "Demo processor test" do
  MOCK_REPORT = "mock report"

  before do
    @processor = DemoProcessor.new
    @table = MiniTest::Mock.new
    @processor.table = @table
  end

  describe "given raw input commands" do
    it "first argument of PLACE must be an integer" do
      assert_equal AppConfig.msg_place_args, @processor.input("PLACE FOO,1,NORTH")
    end

    it "second argument of PLACE must be an integer" do
      assert_equal AppConfig.msg_place_args, @processor.input("PLACE 1,FOO,NORTH")
    end

    it "third argument of PLACE must be either of NORTH/SOUTH/EAST/WEST" do
      assert_equal AppConfig.msg_place_args, @processor.input("PLACE 1,2,FOO")
    end

    it "ignores bad input" do
      assert_equal AppConfig.msg_place_args, @processor.input("FOO BAR")
    end

    it "ignores missing input" do
      assert_equal AppConfig.msg_place_args, @processor.input("")
    end

    it "calls the PLACE method" do
      @table.expect :place, nil, [123, 456, :north]
      @processor.input "PLACE 123,456,NORTH"
      @table.verify
    end

    it "calls the MOVE method" do
      @table.expect :move, nil
      @processor.input "MOVE"
      @table.verify
    end

    it "calls the LEFT method" do
      @table.expect :left, nil
      @processor.input "LEFT"
      @table.verify
    end

    it "calls the RIGHT method" do
      @table.expect :right, nil
      @processor.input "RIGHT"
      @table.verify
    end

    it "calls the REPORT method" do
      @table.expect :report, MOCK_REPORT
      report = @processor.input "REPORT"
      assert_equal MOCK_REPORT, report
    end

    it "is case insensitive" do
      @table.expect :move, nil
      @processor.input "mOvE"
      @table.verify
    end
  end
end