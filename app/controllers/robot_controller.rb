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
    if params[:height].to_i > 0
      @@adapter = RobotAdapter.new params[:height].to_i, params[:width].to_i
    else
      @@adapter = RobotAdapter.new
    end

    set_table_size
    render "robot/input"
  end

  # Used in unit tests because don't know how to access class variable setter from outside classes...?
  def set_adapter(adapter)
    @@adapter = adapter
  end

  # Take an input as GET request parameter and run through the adapter, returning messages to the view
  def input
    @message = @@adapter.input params[:input]

    # Additional view data for the board representation (optional)
    @report = @@adapter.input "REPORT"
    @robot = @@adapter.table.robots[:default]
    set_table_size
  end

  private

  def set_table_size
    @height = @@adapter.table.height
    @width = @@adapter.table.width
  end
end