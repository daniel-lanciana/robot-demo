require 'minitest/autorun'

describe RobotController, "Robot simulator integration tests" do
  describe "when given inputs" do
    it "places the robot" do
      get :index, {'input' => "PLACE 0,0,NORTH"}
      get :index, {'input' => "REPORT"}
      assert_equal "0,0,NORTH", :message
    end

    it "places and moves the robot" do
      get :index, {'input' => "PLACE 0,0,NORTH"}
      get :index, {'input' => "MOVE"}
      get :index, {'input' => "REPORT"}
      assert_equal "0,1,NORTH", :message
    end

    it "places and rotates the robot" do
      get :index, {'input' => "PLACE 0,0,NORTH"}
      get :index, {'input' => "LEFT"}
      get :index, {'input' => "REPORT"}
      assert_equal "0,0,WEST", :message
    end

    it "moves and rotates the robot" do
      get :index, {'input' => "PLACE 1,2,EAST"}
      get :index, {'input' => "MOVE"}
      get :index, {'input' => "MOVE"}
      get :index, {'input' => "LEFT"}
      get :index, {'input' => "MOVE"}
      get :index, {'input' => "REPORT"}
      assert_equal "3,3,NORTH", :message
    end

    it "ignores input before a successful place" do
      get :index, {'input' => "PLACE -1,0,NORTH"}
      get :index, {'input' => "LEFT"}
      get :index, {'input' => "REPORT"}
      refute_match :message, /NORTH/
    end

    it "ensures the robot can't fall off the board" do
      get :index, {'input' => "PLACE 10,2,EAST"}
      get :index, {'input' => "MOVE"}
      get :index, {'input' => "PLACE 5,5,NORTH"}
      get :index, {'input' => "MOVE"}
      get :index, {'input' => "LEFT"}

      7.times do
        get :index, {'input' => "MOVE"}
      end

      get :index, {'input' => "REPORT"}
      assert_equal "0,5,WEST", :message
    end
  end
end