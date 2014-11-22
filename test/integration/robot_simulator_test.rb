require 'test_helper'
require 'minitest/autorun'
require './app/controllers/application_controller'
require './app/controllers/robot_controller'

describe RobotController, "Robot simulator integration tests" do
  describe "when given inputs" do
    before do
      @adapter = RobotAdapter.new
    end

    it "places the robot" do
      @adapter.input "PLACE 0,0,NORTH"
      assert_equal "0,0,NORTH", @adapter.input("REPORT")
    end

    it "places and moves the robot" do
      @adapter.input "PLACE 0,0,NORTH"
      @adapter.input "MOVE"
      assert_equal "0,1,NORTH", @adapter.input("REPORT")
    end

    it "places and rotates the robot" do
      @adapter.input "PLACE 0,0,NORTH"
      @adapter.input "LEFT"
      assert_equal "0,0,WEST", @adapter.input("REPORT")
    end

    it "re-places the robot" do
      @adapter.input "PLACE 0,0,NORTH"
      @adapter.input "MOVE"
      @adapter.input "PLACE 3,4,SOUTH"
      assert_equal "3,4,SOUTH", @adapter.input("REPORT")
    end

    it "moves and rotates the robot" do
      @adapter.input "PLACE 1,2,EAST"
      @adapter.input "MOVE"
      @adapter.input "MOVE"
      @adapter.input "LEFT"
      @adapter.input "MOVE"
      assert_equal "3,3,NORTH", @adapter.input("REPORT")
    end

    it "ignores input before a successful place" do
      @adapter.input "PLACE -1,0,NORTH"
      @adapter.input "LEFT"
      assert_equal AppConfig.msg_place_first, @adapter.input("REPORT")
    end

    it "ensures the robot can't fall off the board" do
      @adapter.input "PLACE 10,2,EAST"
      @adapter.input "MOVE"
      @adapter.input "PLACE 4,4,NORTH"
      @adapter.input "MOVE"
      @adapter.input "LEFT"

      7.times do
        @adapter.input "MOVE"
      end

      assert_equal "0,4,WEST", @adapter.input("REPORT")
    end

    it "returns nothing on successful place" do
      assert_empty @adapter.input("PLACE 0,0,NORTH")
    end

    it "returns nothing on rotate left" do
      assert_empty @adapter.input("LEFT")
    end

    it "returns nothing on rotate right" do
      assert_empty @adapter.input("RIGHT")
    end

    it "returns nothing on move forward" do
      assert_empty @adapter.input("MOVE")
    end
  end

  describe "when modifying the table size larger" do
    before do
      @adapter = RobotAdapter.new 10, 8
    end

    it "can place the robot outside the default boundaries" do
      @adapter.input "PLACE 7,7,NORTH"
      assert_equal "7,7,NORTH", @adapter.input("REPORT")
    end
  end

  describe "when modifying the table size smaller" do
    before do
      @adapter = RobotAdapter.new 2, 3
    end

    it "cannot place the robot in a position valid with default table size" do
      @adapter.input "PLACE 3,3,NORTH"
      assert_equal AppConfig.msg_place_first, @adapter.input("REPORT")
    end
  end
end