# frozen_string_literal: true

# Store class that has name, position and menu
class Store
  attr_accessor :name, :position, :menu

  def initialize(name, position, menu)
    @name = name
    @position = position
    @menu = menu
  end

  def display_menu(count_menu)
    i = 1
    menu.each do |food|
      puts "#{i}. #{food.name} #{food.price}"
      i += 1
    end
    puts "#{count_menu + 1}. Finish Order"
    puts "#{count_menu + 2}. Back"
  end
end
