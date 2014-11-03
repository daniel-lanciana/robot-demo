class RobotController < ApplicationController
  attr_accessor :adapter

  def index
    @message = adapter.input params[:input]
  end
end