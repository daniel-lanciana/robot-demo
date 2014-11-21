require 'test_helper'
require 'minitest/autorun'
require './app/models/table'

describe Table, "Table class tests" do
  before do
    @table = Table.new
  end

  it "returns default table width of 5" do
    assert_equal 5, @table.width
  end

  it "returns default table height of 5" do
    assert_equal 5, @table.height
  end

  describe "before the robot is successfully placed" do
    it "cannot be placed off the table in negative position" do
      @table.place -1, -1, :north
      @table.report.must_equal AppConfig.msg_place_first
    end

    it "cannot be placed off the table" do
      @table.place @table.height + 1, @table.width + 1, :north
      @table.report.must_equal AppConfig.msg_place_first
    end

    it "report command is ignored" do
      @table.report.must_equal AppConfig.msg_place_first
    end
  end

  describe "placing the robot on the table" do
    before do
      @table.place 0, 0, :north
    end

    it "successful placement" do
      @table.report.must_equal "0,0,NORTH"
    end

    it "re-place robot" do
      @table.place 3, 3, :south
      @table.report.must_equal "3,3,SOUTH"
    end
  end

  describe "moving the robot forward" do
    before do
      @table.place 0, 0, :north
    end

    it "forward one block" do
      @table.move
      @table.report.must_equal "0,1,NORTH"
    end

    it "forward two block" do
      2.times do
        @table.move
      end
      @table.report.must_equal "0,2,NORTH"
    end
  end

  describe "rotating the robot" do
    before do
      @table.place 0, 0, :north
    end

    it "rotate left once" do
      @table.left
      @table.report.must_equal "0,0,WEST"
    end

    it "rotate left twice" do
      2.times do
        @table.left
      end
      @table.report.must_equal "0,0,SOUTH"
    end

    it "rotate left thrice" do
      3.times do
        @table.left
      end
      @table.report.must_equal "0,0,EAST"
    end

    it "rotate left one full rotation" do
      4.times do
        @table.left
      end
      @table.report.must_equal "0,0,NORTH"
    end

    it "rotate right once" do
      @table.right
      @table.report.must_equal "0,0,EAST"
    end

    it "rotate right twice" do
      2.times do
        @table.right
      end
      @table.report.must_equal "0,0,SOUTH"
    end

    it "rotate right thrice" do
      3.times do
        @table.right
      end
      @table.report.must_equal "0,0,WEST"
    end

    it "rotate right one full rotation" do
      4.times do
        @table.right
      end
      @table.report.must_equal "0,0,NORTH"
    end
  end
end