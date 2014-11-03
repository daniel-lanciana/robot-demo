# For mixin with Robot class (does not make sense for Robot to extend Table -> Robot 'is not' a Table). Allows for
# extensibility through different table sizes (square) and the possibility of obstructions.
module Table
  def self.length
    5 #AppConfig.table_length
  end
end