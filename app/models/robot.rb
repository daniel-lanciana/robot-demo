require './app/models/array'
require './app/models/table'

# Object representing the robot on the tabletop. States are placement (boolean), x pos, y pos and direction facing
# (symbol).
class Robot
  # Array must be in clockwise order for traversing next/prev
  DIRECTIONS = [:north, :east, :south, :west]

  # Mixin for table dimensions
  include Table

  # Use boolean to represent placed rather than facing value (more code, but more readable)
  attr_accessor :placed
  attr_accessor :pos_x
  attr_accessor :pos_y
  attr_accessor :facing

  # Place the robot on the table (if valid x, y positions). Returns empty string.
  def place(pos_x, pos_y, facing)
    if Robot.valid_placement?(pos_x) && Robot.valid_placement?(pos_y)
      @pos_x, @pos_y, @facing = pos_x, pos_y, facing
      @placed = true
      ""
    end
  end

  # If on the table, rotate the robot 90 degrees left. Returns empty string.
  def left
    if @placed then
      @facing = DIRECTIONS.prev_elem_infinite(@facing)
    end
    ""
  end

  # If on the table, rotate the robot 90 degrees right. Returns empty string.
  def right
    if @placed then
      @facing = DIRECTIONS.next_elem_infinite(@facing)
    end
    ""
  end

  # If on the table, move the robot forward one position. Returns empty string.
  def move
    if @placed then move_forward end
    ""
  end

  # If on the table, report the robot's position and direction -- otherwise return an error message
  def report
    if @placed then "#{@pos_x},#{@pos_y},#{@facing}".upcase
    else
      AppConfig.msg_place_first
    end
  end

  private

  # Depending on the direction facing, move the robot forward by passing the instance variable identifier and a block
  # containing the logic to move up/down a position.
  def move_forward
    case @facing
      when :north
        update_pos('pos_y') { +1 }
      when :south
        update_pos('pos_y') { -1 }
      when :east
        update_pos('pos_x') { +1 }
      when :west
        update_pos('pos_x') { -1 }
    end
  end

  # If a valid move, updates the robot's position
  def update_pos(name, &block)
    # Get the proposed position
    pos = self.send(name) + block.call

    if Robot.valid_placement?(pos)
      # If valid, set the relevant instance variable with the new position
      instance_variable_set("@#{name}", pos)
    end
  end

  # Static method to check if position is on the table. Returns TRUE if the position is on the table.
  def self.valid_placement?(pos)
    if pos.between?(0, Table.length - 1)
      return true
    end
  end
end