require 'minitest/autorun'

describe RobotController, "Robot controller tests" do
  before do
    @controller = RobotController.new
    @adapter = MiniTest::Mock.new
    @controller.adapter = @adapter
  end

  after do
    @controller.destroy!
  end

  describe "input passed to the controller" do
    it "is passed to the adapter service" do
      @adapter.expect :input, nil, ["FOO"]
      # Not sure about syntax to set the params[:input => 'FOO'] passed from the web to the method
      @controller.params = {:input => 'FOO'}
      @controller.index
      @adapter.verify
    end
  end

  describe "output returned from the adapter service" do
    it "is put in the params" do
      @adapter.expect :input, "FOO", []
      @controller.index
      # Not sure if this is the best way to test an instance variable passed from controller accessible in the view
      assert_equal "FOO", @nessage
    end
  end
end