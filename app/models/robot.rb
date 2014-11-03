require './app/models/array'
require './app/models/table'

class Robot
  # Array must be in clockwise order for traversing next/prev
  DIRECTIONS = [:north, :east, :south, :west]

  include Table

  # Use boolean to represent placed rather than facing value (more code, but more readable)
  attr_accessor :placed
  attr_accessor :pos_x
  attr_accessor :pos_y
  attr_accessor :facing

  def place(pos_x, pos_y, facing)
    if valid_placement?(pos_x) && valid_placement?(pos_y)
      # Can't auto set arguments to instance variables without meta-programming
      @pos_x, @pos_y, @facing = pos_x, pos_y, facing
      @placed = true
    end
  end

  def left
    if @placed then
      @facing = DIRECTIONS.prev_elem_infinite(@facing)
    end
  end

  def right
    if @placed then
      @facing = DIRECTIONS.next_elem_infinite(@facing)
    end
  end

  def move
    if @placed then move_forward end
  end

  def report
    if @placed then "#{@pos_x},#{@pos_y},#{@facing}".upcase
    else
      AppConfig.msg_place_first
    end
  end

  private

  # Default return is false
  def valid_placement?(pos)
    if pos.between?(0, Table.length - 1)
      return true
    end
  end

  def update_pos(name, &block)
    pos = self.send(name) + block.call

    if valid_placement?(pos)
      instance_variable_set("@#{name}", pos)
    end
  end

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
end