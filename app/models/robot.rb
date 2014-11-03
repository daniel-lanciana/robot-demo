require './app/models/array'
require './app/models/table'

class Robot
  MSG_PLACE_FIRST = 'Please place the robot on the table first...' #AppConfig.msg.place_first
  # Array must be in order
  DIRECTIONS = [:north, :east, :south, :west]

  include Table

  # Use boolean to represent placed rather than facing value (more code, but more readable)
  attr_accessor :placed
  attr_accessor :pos_x
  attr_accessor :pos_y
  attr_accessor :facing

  def place(pos_x, pos_y, facing)
    if valid_placement?(pos_x, pos_y)
      # Can't auto set arguments to instance variables without meta-programming
      @pos_x, @pos_y, @facing = pos_x, pos_y, facing
      @placed = true
    end
  end

  def left
    if @placed then
      @facing = DIRECTIONS.prev_elem_infinite(@facing)
    end
    # if @placed then rotate_left end
  end

  def right
    if @placed then
      @facing = DIRECTIONS.next_elem_infinite(@facing)
    end
    # if @placed then rotate_right end
  end

  def move
    if @placed then move_forward end
  end

  def report
    if @placed then "#{@pos_x},#{@pos_y},#{@facing}".upcase
    else
      MSG_PLACE_FIRST
    end
  end

  private

  def valid_placement?(pos_x, pos_y)
    if (pos_x < 0 || pos_x > Table.width)
      return false
    elsif (pos_y < 0 || pos_y > Table.height)
      return false
    end

    return true
  end

=begin
  def rotate_left
    case @facing
      when :north
        @facing = :west
      when :south
        @facing = :east
      when :east
        @facing = :north
      # No else statement because we want to ignore potential bad input
      when :west
        @facing = :south
    end
  end

  def rotate_right
    case @facing
      when :north
        @facing = :east
      when :south
        @facing = :west
      when :east
        @facing = :south
      # No else statement because we want to ignore potential bad input
      when :west
        @facing = :north
    end
  end
=end

  def move_forward
    case @facing
      when :north
        if valid_move?(:y, @pos_y + 1)
          @pos_y = @pos_y + 1
        end
      when :south
        if valid_move?(:y, @pos_y - 1)
          @pos_y = @pos_y - 1
        end
      when :east
        if valid_move?(:x, @pos_x + 1)
          @pos_x = @pos_x + 1
        end
      # No else statement because we want to ignore potential bad input
      when :west
        if valid_move?(:x, @pos_x - 1)
          @pos_x = @pos_x - 1
        end
    end
  end

  def valid_move?(axis, proposed_pos)
    if (proposed_pos < 0)
      return false
    elsif (axis.equal?(:x) && proposed_pos > Table.width)
      return false
    elsif (axis.equal?(:y) && proposed_pos > Table.height)
      return false
    end

    true
  end
end