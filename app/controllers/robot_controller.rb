require './app/services/robot_adapter'

# Web application access to the adapter class
class RobotController < ApplicationController
  # Class variable to keep singleton object between requests (stateful). Bad web application design, but wen only for
  # convenience. For concurrent use, store object in an object store such as session or a database.
  @@adapters = {} #RobotAdapter.new

  # On initial load, re-initialise the adapter destorying any previous state (i.e. reset)
  def init
    # If setting a custom table height or width
    if params[:height].to_i > 0
      @@adapters[request.session_options[:id].to_sym] = RobotAdapter.new params[:height].to_i, params[:width].to_i
    else
      @@adapters[request.session_options[:id].to_sym] = RobotAdapter.new
    end

    set_table_size
    render "robot/input"
  end

  # Take an input as GET request parameter and run through the adapter, returning messages to the view
  def input
    adapter = @@adapters[request.session_options[:id].to_sym]

    @message = adapter.input params[:input]
    # Additional view data for the board representation (optional)
    @report = adapter.input "REPORT"
    @robot = adapter.table.robots[:default]
    set_table_size
  end

  private

  def set_table_size
    adapter = @@adapters[request.session_options[:id].to_sym]

    @height = adapter.table.height
    @width = adapter.table.width
  end
end