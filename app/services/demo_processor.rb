# From the raw input performs validation and calls the relevant Robot methods. Adapter pattern.
class DemoProcessor
  attr_accessor :table

  # On initialisation, create the Table
  def initialize(height = AppConfig.default_height, width = AppConfig.default_width)
    @table = Table.new height, width
  end

  # Validates and parses the input, calls relevant Robot methods
  def input(input)
    cleaned_input = sanatise_input input

    if valid_input? cleaned_input
      process_input cleaned_input
    else
      # Return error message
      return AppConfig.msg_place_args
    end
  end

  private

  # Clean up the input for parsing
  def sanatise_input(input)
    if input == nil
      ''
    else
      input.strip.downcase
    end
  end

  # Returns TRUE if a valid command
  def valid_input?(input)
    if input.match(/(move|right|left|report)/) || input.match(/place [0-9]+,[0-9]+,(north|south|east|west)/)
      true
    end
  end

  def process_input(input)
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
        # If a valid PLACE command, strip the arguments out and call .place
        args = input.gsub("place ", "").split(",")
        @table.place(args[0].to_i, args[1].to_i, args[2].to_sym)
    end
  end
end