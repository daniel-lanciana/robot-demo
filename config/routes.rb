Rails.application.routes.draw do
  root 'robot#init'
  get 'robot/input'
  # Dynamicalls calls the method in the RobotController based on the :action
  get 'robot/:action' => 'robot'
end
