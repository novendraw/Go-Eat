# frozen_string_literal: true

# Driver class that has driver name, position and rating
class Driver
  attr_accessor :name, :position, :rating

  def initialize(name, position, rating)
    @name = name
    @position = position
    @rating = rating
  end
end
