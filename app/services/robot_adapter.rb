# From the raw input performs validation and calls the relevant Robot methods. Adapter pattern.
class RobotAdapter
  attr_accessor :table

  # On initialisation, create the Table
  def initialize(height = AppConfig.default_height, width = AppConfig.default_width)
    @table = Table.new height, width
  end

  # Validates and parses the input, calls relevant Robot methods
  def input(input)
    if input != nil
      input = input.strip.downcase

      # In order of anticipated usage from most to least
      case input
        when "move"
          @table.move
        when "right"
          @table.right
          ""
        when "left"
          @table.left
          ""
        when "report"
          @table.report
        else
          if RobotAdapter.valid_place_command?(input)
            # If a valid PLACE command, strip the arguments out and call .place
            args = input.gsub("place ", "").split(",")
            @table.place(args[0].to_i, args[1].to_i, args[2].to_sym)
          else
            # Return error message
            return AppConfig.msg_place_args
          end
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