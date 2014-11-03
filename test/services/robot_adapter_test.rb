require 'minitest/autorun'
require './app/services/robot_adapter'

# Unit tests to ensure the raw input is validated and adapted to the relevant Robot model calls.
describe RobotAdapter, "Robot adapter test" do
  MOCK_REPORT = "mock report"
  MSG_PLACE_ARGS = "Invalid PLACE command arguments: x-position, y-position, NORTH/SOUTH/EAST/WEST" #AppConfig.msg.place_args

  before do
    @adapter = RobotAdapter.new
    @robot = MiniTest::Mock.new
    @adapter.robot = @robot
  end

  describe "given raw input commands" do
    it "first argument of PLACE must be an integer" do
      assert_equal MSG_PLACE_ARGS, @adapter.input("PLACE FOO,1,NORTH")
    end

    it "second argument of PLACE must be an integer" do
      assert_equal MSG_PLACE_ARGS, @adapter.input("PLACE 1,FOO,NORTH")
    end

    it "third argument of PLACE must be either of NORTH/SOUTH/EAST/WEST" do
      assert_equal MSG_PLACE_ARGS, @adapter.input("PLACE 1,2,FOO")
    end

    it "ignores bad input" do
      assert_equal MSG_PLACE_ARGS, @adapter.input("FOO BAR")
    end

    it "ignores missing input" do
      assert_equal MSG_PLACE_ARGS, @adapter.input("")
    end

    it "calls the PLACE method" do
      @robot.expect(:place, nil, [123, 456, "north"])
      @adapter.input("PLACE 123,456,NORTH")
      @robot.verify
    end

    it "calls the MOVE method" do
      @robot.expect(:move, nil)
      @adapter.input("MOVE")
      @robot.verify
    end

    it "calls the LEFT method" do
      @robot.expect(:left, nil)
      @adapter.input("LEFT")
      @robot.verify
    end

    it "calls the RIGHT method" do
      @robot.expect(:right, nil)
      @adapter.input("RIGHT")
      @robot.verify
    end

    it "calls the REPORT method" do
      @robot.expect(:report, MOCK_REPORT)
      report = @adapter.input("REPORT")
      assert_equal MOCK_REPORT, report
    end

    it "is case insensitive" do
      @robot.expect(:move, nil)
      @adapter.input("mOvE")
      @robot.verify
    end
  end
end