require 'test_helper'
require 'minitest/autorun'
require './app/controllers/application_controller'
require './app/controllers/robot_controller'

describe RobotController, "Robot controller tests" do
  before do
    @controller = RobotController.new
    @adapter = MiniTest::Mock.new
    @controller.adapter = @adapter
    @controller.params = {:input => 'FOO'}
  end

  describe "input passed to the controller" do
    it "is passed to the adapter service" do
      @adapter.expect :input, nil, ["FOO"]
      @controller.index
      @adapter.verify
    end
  end

  describe "output returned from the adapter service" do
    it "exists and is put into an instance variable for display in the view" do
      @adapter.expect :input, "BAR", ["FOO"]
      @controller.index
      # Not sure if this is the best way to test an instance variable passed from controller accessible in the view
      assert_equal "BAR", @controller.instance_variable_get("@message")
    end
  end
end