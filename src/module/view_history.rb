# frozen_string_literal: true

# View History Director
# module for view_history command
module ViewHistory
  # write routes to file
  def self.write_routes(user, store, driver)
    file = File.open('data/history_with_routes.txt', 'a')
    if driver.position != store.position
      file.print ' - driver is on the way to store, start at '
      file.print "(#{driver.position[0]},#{driver.position[1]})"
      write_route_steps(file, driver, store)
      file.print ', '
    end
    file.puts 'driver arrived at the store!'
    if store.position != user.position
      file.print ' - driver has bought the item(s), start at '
      file.print "(#{store.position[0]},#{store.position[1]})"
      write_route_steps(file, store, user)
      file.print ', '
    end
    file.puts 'driver arrived at your place!'
    file.puts ''
    file.close
  end

  # write route steps to file
  def self.write_route_steps(file, start_point, end_point)
    start_x = start_point.position[0]
    end_x = end_point.position[0]
    start_y = start_point.position[1]
    end_y = end_point.position[1]
    while start_x != end_x
      start_x < end_x ? start_x += 1 : start_x -= 1
      file.print "\n - go to (#{start_x},#{start_y})"
    end
    while start_y != end_y
      start_y < end_y ? start_y += 1 : start_y -= 1
      file.print "\n - go to (#{start_x},#{start_y})"
    end
  end

  def self.write_to_history(user, store, driver, sum)
    input = 7
    until input.between?(1, 5)
      puts 'Give rating for driver?(1 - 5)'
      input = STDIN.gets.chomp.to_f
    end
    file = File.open('data/history.txt', 'a')
    file.puts "Rating : #{input}"
    file.puts "Driver : #{driver.name}"
    file.puts "Store : #{store.name}(#{store.position[0]},#{store.position[1]})"
    file.puts "Destinations : (#{user.position[0]},#{user.position[1]})"
    file.puts "Total Payment : #{sum}"
    file.puts ''
    file.close
    file = File.open('data/history_with_routes.txt', 'a')
    file.puts "Rating : #{input}"
    file.puts "Driver : #{driver.name}"
    file.puts "Store : #{store.name}(#{store.position[0]},#{store.position[1]})"
    file.puts "Destinations : (#{user.position[0]},#{user.position[1]})"
    file.puts "Total Payment : #{sum}"
    file.puts 'Routes :'
    file.close
    write_routes(user, store, driver)
    return input if driver.rating.zero?

    (input + driver.rating.to_f) / 2.0
  end

  # view history from file
  def self.view_history
    if File.exist?('data/history.txt')
      file = File.open('data/history.txt', 'r')
      file.each_line(&method(:puts))
      file.close
    else
      puts 'Not A Single Order Was Made'
    end
  end
end
