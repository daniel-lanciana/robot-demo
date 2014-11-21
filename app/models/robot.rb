require './app/models/array'
require './app/models/table'

# Object representing the robot on the tabletop. States are placement (boolean), x pos, y pos and direction facing
# (symbol).
class Robot
  attr_accessor :id
  attr_accessor :pos_x
  attr_accessor :pos_y
  attr_accessor :direction
end