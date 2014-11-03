class RobotAdapter
  attr_accessor :robot

  def input(input)
    input = input.strip.downcase

    # In order of anticipated usage from most to least
    case input
      when "move"
        robot.move
      when "right"
        robot.right
      when "left"
        robot.left
      when "report"
        robot.report
      else
        if valid_place_command?(input)
          args = input.gsub("place ", "").split(",")
          robot.place(args[0].to_i, args[1].to_i, args[2])
        else
          AppConfig.msg_place_args
        end
    end
  end

  private

  def valid_place_command?(input)
    if input.match(/place [0-9]+,[0-9]+,(north|south|east|west)/)
      true
    end
  end
end