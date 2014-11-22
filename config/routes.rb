Rails.application.routes.draw do
  root 'robot#init'
  get 'robot/input'
end
