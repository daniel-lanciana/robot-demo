# From the raw input performs validation and calls the relevant Robot methods. Adapter pattern.
class RobotAdapter
  attr_accessor :robot

  # On initialisation, create a new Robot object
  def initialize(*args)
    @robot = Robot.new
  end

  # Validates and parses the input, calls relevant Robot methods
  def input(input)
    input = input.strip.downcase

    # In order of anticipated usage from most to least
    case input
      when "move"
        @robot.move
      when "right"
        @robot.right
      when "left"
        @robot.left
      when "report"
        @robot.report
      else
        if RobotAdapter.valid_place_command?(input)
          # If a valid PLACE command, strip the arguments out and call .place
          args = input.gsub("place ", "").split(",")
          @robot.place(args[0].to_i, args[1].to_i, args[2].to_sym)
        else
          # Return error message
          AppConfig.msg_place_args
        end
    end
  end

  private

  # Returns TRUE if the PLACE command matches the regular expression.
  def self.valid_place_command?(input)
    if input.match(/place [0-9]+,[0-9]+,(north|south|east|west)/)
      true
    end
  end
end