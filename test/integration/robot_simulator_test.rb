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
      @adapter.input "REPORT"
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
      puts @adapter.input("REPORT")
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
  end
end