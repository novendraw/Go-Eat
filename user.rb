# frozen_string_literal: true

# User class that has user position and history
class User
  attr_accessor :position, :history

  def initialize(position, history)
    @position = position
    @history = history
  end
end
