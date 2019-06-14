# frozen_string_literal: true

# Food class that has name, price and quantity attributes
class Food
  attr_accessor :name, :price, :quantity

  def initialize(name, price, quantity)
    @name = name
    @price = price
    @quantity = quantity
  end

  def display_ordered_items
    puts "#{name}X#{quantity} = #{price * quantity}"
  end
end