# frozen_string_literal: true

# Class that work as builder
module Action
  def self.show_map(size)
    i = 1
    until i > size
      j = 1
      while j <= size
        print ' #'
        j += 1
      end
      puts ''
      i += 1
    end
  end
end
