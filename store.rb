# frozen_string_literal: true

# Store class that has name, position and menu
class Store
  attr_accessor :name, :position, :menu

  def initialize(name, position, menu)
    @name = name
    @position = position
    @menu = menu
  end

  def display_menu
    puts 'Menu :'
    i = 1
    menu.each do |food|
      puts "#{i}. #{food.name}"
      puts "   #{food.price}"
      i += 1
    end
  end
end
