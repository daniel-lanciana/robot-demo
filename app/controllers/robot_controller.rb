require './app/services/robot_adapter'

# Web application access to the adapter class
class RobotController < ApplicationController
  # Class variable to keep singleton object between requests (stateful). Bad web application design, but wen only for
  # convenience. For concurrent use, store object in an object store such as session or a database.
  @@adapter = RobotAdapter.new

  # Class variable getter/setter. class << self opens up the singleton class of 'self'
  class << self
    attr_accessor :adapter
  end

  # On initial load, re-initialise the adapter destorying any previous state (i.e. reset)
  def init
    @@adapter = RobotAdapter.new
    render "robot/input"
  end

  # Take an input as GET request parameter and run through the adapter, returning messages to the view
  def input
    @message = @@adapter.input params[:input]

    # Debug stuff
    @report = @@adapter.input "REPORT"
    @robot = @@adapter.robot
  end
end