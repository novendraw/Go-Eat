# frozen_string_literal: true

# Class that work as builder
module Action
  def self.show_map(size, map)
    i = 1
    while i <= size
      j = 1
      while j <= size
        print map[[i, j]]
        j += 1
      end
      puts ''
      i += 1
    end
  end

  def self.order_food
    puts 'here'
  end

  def self.view_history
    puts 'here'
  end
end
