# frozen_string_literal: true

# Driver class that has driver position and rating
class Driver
  attr_accessor :position, :rating

  def initialize(position, rating)
    @position = position
    @rating = rating
  end
end
