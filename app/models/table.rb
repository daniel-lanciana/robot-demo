# For mixin with Robot class (does not make sense for Robot to extend Table -> Robot 'is not' a Table). Allows for
# extensibility through different table sizes (square) and the possibility of obstructions.
class Table
  # Array must be in clockwise order for traversing next/prev
  DIRECTIONS = [:north, :east, :south, :west]

  attr_accessor :height
  attr_accessor :width
  attr_accessor :robots

  def initialize(height, width)
    @height = height
    @width = width
    # Empty hash of robots on the table to start
    @robots = {}
  end

  # Place the robot on the table (if valid x, y positions). Returns empty string.
  def place(id = 'default', pos_x, pos_y, direction)
    if valid_placement?('pos_x', pos_x) && valid_placement?('pos_y', pos_y)
      robot = Robot.new
      robot.id, robot.pos_x, robot.pos_y, robot.direction = id, pos_x, pos_y, direction
      robots[id.to_sym] = robot
      ""
    end
  end

  # If on the table, move the robot forward one position. Returns empty string.
  def move(id = 'default')
    robot = @robots[id.to_sym]
    if robot then move_forward(robot) end
    ""
  end

  # If on the table, report the robot's position and direction -- otherwise return an error message
  def report(id = 'default')
    robot = @robots[id.to_sym]
    if robot then "#{robot.pos_x},#{robot.pos_y},#{robot.direction}".upcase
    else
      AppConfig.msg_place_first
    end
  end

  # If on the table, rotate the robot 90 degrees left. Returns empty string.
  def left(id = 'default')
    robot = @robots[id.to_sym]
    if robot then robot.direction = DIRECTIONS.prev_elem_infinite(robot.direction) end
    ""
  end

  # If on the table, rotate the robot 90 degrees right. Returns empty string.
  def right(id = 'default')
    robot = @robots[id.to_sym]
    if robot then robot.direction = DIRECTIONS.next_elem_infinite(robot.direction) end
    ""
  end

  private

  # Depending on the direction, move the robot forward by passing the instance variable identifier and a block
  # containing the logic to move up/down a position.
  def move_forward(robot)
    case robot.direction
      when :north
        update_pos(robot, 'pos_y') { +1 }
      when :south
        update_pos(robot, 'pos_y') { -1 }
      when :east
        update_pos(robot, 'pos_x') { +1 }
      when :west
        update_pos(robot, 'pos_x') { -1 }
    end
  end

  # If a valid move, updates the robot's position
  def update_pos(robot, property, &block)
    # Get the proposed position
    pos = robot.send(property) + block.call

    if valid_placement?(property, pos)
      # If valid, set the relevant instance variable with the new position
      robot.instance_variable_set("@#{property}", pos)
    end
  end

  # Static method to check if position is on the table. Returns TRUE if the position is on the table.
  def valid_placement?(property, pos)
    if property === 'pos_x' && pos.between?(0, @width - 1)
      return true
    elsif property === 'pos_y' && pos.between?(0, @height - 1)
      return true
    end
  end
end