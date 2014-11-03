# For mixin with Robot class (does not make sense for Robot to extend Table -> Robot 'is not' a Table). Allows for
# extensibility through different table sizes and the possibility of obstructions.
module Table
  def self.height
    5 #AppConfig.table_height
  end

  def self.width
    5 #AppConfig.table_width
  end
end