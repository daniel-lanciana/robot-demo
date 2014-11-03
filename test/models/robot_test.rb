require 'minitest/autorun'

describe Robot, "Robot model tests" do
  before do
    @robot = Robot.new
  end

  after do
    @robot.destroy!
  end

  describe "before the robot is successfully placed" do
    it "cannot be placed off the table in negative position" do
      @robot.place -1, -1, :north
      @robot.report.must_equal AppConfig.msg.place_first
    end

    it "cannot be placed off the table" do
      @robot.place Table.height + 1, Table.width + 1, :north
      @robot.report.must_equal AppConfig.msg.place_first
    end

    it "left command is ignored" do
      @robot.left
      @robot.report.must_equal AppConfig.msg.place_first
    end

    it "right command is ignored" do
      @robot.right
      @robot.report.must_equal AppConfig.msg.place_first
    end

    it "report command is ignored" do
      @robot.report.must_equal AppConfig.msg.place_first
    end
  end

  describe "placing the robot on the table" do
    it "successful placement" do
      @robot.place 0, 0, :north
      @robot.report.must_equal "0,0,NORTH"
    end

    it "re-place robot" do
      @robot.place 3, 3, :south
      @robot.report.must_equal "3,3,SOUTH"
    end
  end

  describe "rotating the robot" do
    before do
      @robot.place 0, 0, :north
    end

    it "rotate left once" do
      @robot.left
      @robot.report.must_equal "0,0,WEST"
    end

    it "rotate left twice" do
      2.times do
        @robot.left
      end
      @robot.report.must_equal "0,0,SOUTH"
    end

    it "rotate left thrice" do
      3.times do
        @robot.left
      end
      @robot.report.must_equal "0,0,EAST"
    end

    it "rotate left one full rotation" do
      4.times do
        @robot.left
      end
      @robot.report.must_equal "0,0,NORTH"
    end

    it "rotate right once" do
      @robot.right
      @robot.report.must_equal "0,0,EAST"
    end

    it "rotate right twice" do
      2.times do
        @robot.right
      end
      @robot.report.must_equal "0,0,SOUTH"
    end

    it "rotate right thrice" do
      3.times do
        @robot.right
      end
      @robot.report.must_equal "0,0,WEST"
    end

    it "rotate right one full rotation" do
      4.times do
        @robot.right
      end
      @robot.report.must_equal "0,0,NORTH"
    end
  end

  describe "moving the robot forward" do
    before do
      @robot.place 0, 0, :north
    end

    it "forward one block" do
      @robot.move
      @robot.report.must_equal "0,1,NORTH"
    end

    it "forward two block" do
      2.times do
        @robot.move
      end
      @robot.report.must_equal "0,2,NORTH"
    end

    it "moving off the table is ignored" do
      (Table.height + 1).times do
        @robot.move
      end
      @robot.report.must_equal "0,5,NORTH"
    end
  end

  describe "combined moving and rotating the robot" do
    it "all over the place" do
      @robot.place 1, 2, :east

      2.times do
        @robot.move
      end

      @robot.left
      @robot.move
      @robot.report.must_equal "3,3,NORTH"
    end

    it "can't be moved off the table on any side (assuming table is a square)" do
      @robot.place 0, 0, :north

      4.times do
        (Table.height + 1).times do
          @robot.move
        end

        @robot.right
      end

      @robot.report.must_equal "0,0,WEST"
    end
  end
end