require './app/services/demo_processor'

# Web application access to the adapter class
class RobotController < ApplicationController
  # Class variable to keep singleton object between requests (stateful). Bad web application design, but wen only for
  # convenience. For concurrent use, store object in an object store such as session or a database.
  @@adapters = {} #DemoProcessor.new

  # On initial load, re-initialise the adapter destorying any previous state (i.e. reset)
  def init
    # Session lazy loaded (i.e. not loaded) on production! Force session creation
    # http://stackoverflow.com/questions/14665275/how-force-that-session-is-loaded
    session["init"] = true

    # If setting a custom table height or width
    if params[:height].to_i > 0
      @@adapters[request.session_options[:id].to_sym] = DemoProcessor.new params[:height].to_i, params[:width].to_i
    else
      @@adapters[request.session_options[:id].to_sym] = DemoProcessor.new
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

  # Default is 0,0,NORTH
  def place
    x = params[:x] ? params[:x] : 0
    y = params[:y] ? params[:y] : 0
    direction = params[:direction] ? params[:direction] : "NORTH"

    perform_action "PLACE "+ x.to_s + "," + y.to_s + "," + direction
  end

  def move
    perform_action "MOVE"
  end

  def left
    perform_action "LEFT"
  end

  def right
    perform_action "RIGHT"
  end

  def report
    perform_action "REPORT"
  end

  private

  def perform_action(action)
    adapter = @@adapters[request.session_options[:id].to_sym]

    if adapter != nil
      @message = adapter.input action
      render status: 200, :json => adapter.input("REPORT")
    else
      render status: 400, :json => AppConfig.msg_place_first
    end
  end

  def set_table_size
    adapter = @@adapters[request.session_options[:id].to_sym]

    @height = adapter.table.height
    @width = adapter.table.width
  end
end