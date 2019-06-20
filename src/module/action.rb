# frozen_string_literal: true

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

  def self.display_stores(stores, iterator)
    while iterator <= stores.size
      puts "#{iterator}. #{stores[iterator - 1].name}"
      iterator += 1
    end
    puts "#{iterator}. Back"
    iterator
  end

  def self.order_food(stores)
    display_stores(stores, 1)
    input = STDIN.gets.chomp.to_i
    order_food(stores) if input > (stores.size + 1) || input < 1
    return 0 if input == stores.size + 1

    store_number = input - 1
    return 0 if stores[store_number].nil?

    choose_menu(stores, store_number, stores[store_number].menu)
  end

  def self.choose_menu(stores, store_number, order)
    count_menu = stores[store_number].menu.size
    stores[store_number].display_menu(count_menu)
    input = STDIN.gets.chomp.to_i
    case input
    when 1..(count_menu + 2)
      order_case(stores, input, count_menu, store_number, order)
    else
      choose_menu(stores, store_number, order)
    end
  end

  def self.add_order(input, order, stores, store_number)
    order[input].quantity += 1
    confirm_order(stores, store_number, order)
  end

  def self.order_case(stores, input, count_menu, store_number, order)
    case input
    when count_menu + 2
      go_back_from_order(input, stores, store_number, order)
    when count_menu + 1
      order_data = [order, store_number]
      return 0 if stores[store_number].nil?

      order_data
    else
      add_order(input - 1, order, stores, store_number)
    end
  end

  def self.confirm_order(stores, store_number, order)
    puts '1. Add More Items'
    puts '2. Finish Order'
    input = STDIN.gets.chomp.to_i
    case input
    when 1
      choose_menu(stores, store_number, order)
    when 2
      order_data = [order, store_number]
      return order_data
    else
      return confirm_order(stores, store_number, order)
    end
  end

  def self.finish_order(data)
    puts 'Ordered Items :'
    data[0].each(&:display_ordered_items)
    nearest_driver = pick_nearest_driver(data[3], data[2], data[5])
    fee = count_delivery_fee(data[1], data[2], data[3][nearest_driver], data[4])
    puts "Delivery Fee : #{fee}"
    puts "Total Price = #{fee + data[6]}"
    # puts 'Are You Sure?(y/n)'
    # input = STDIN.gets.chomp
    # input == 'n' ? choose_menu(stores, store_number, data[0]) : nearest_driver
    nearest_driver
  end

  def self.pick_nearest_driver(drivers, store, map_size)
    picked_driver = 0
    i = 0
    min = map_size * 2 + 1
    drivers.each do |driver|
      distance = count_distance(driver, store)
      if distance < min
        min = distance
        picked_driver = i
      end
      i += 1
    end
    picked_driver
  end

  def self.display_routes(user, store, driver)
    if driver.position != store.position
      print ' - driver is on the way to store, start at '
      print "(#{driver.position[0]},#{driver.position[1]})"
      display_route_steps(driver, store)
      print ', '
    end
    puts 'driver arrived at the store!'
    if store.position != user.position
      print ' - driver has bought the item(s), start at '
      print "(#{store.position[0]},#{store.position[1]})"
      display_route_steps(store, user)
      print ', '
    end
    puts 'driver arrived at your place!'
  end

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

  def self.display_route_steps(start_point, end_point)
    start_x = start_point.position[0]
    end_x = end_point.position[0]
    start_y = start_point.position[1]
    end_y = end_point.position[1]
    while start_x != end_x
      start_x < end_x ? start_x += 1 : start_x -= 1
      print "\n - go to (#{start_x},#{start_y})"
    end
    while start_y != end_y
      start_y < end_y ? start_y += 1 : start_y -= 1
      print "\n - go to (#{start_x},#{start_y})"
    end
  end

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

  def self.count_distance(start_point, end_point)
    x = (start_point.position[0] - end_point.position[0]).abs
    y = (start_point.position[1] - end_point.position[1]).abs
    x + y
  end

  def self.count_delivery_fee(user, store, driver, unit_cost)
    total_distance = count_distance(user, store) + count_distance(driver, store)
    unit_cost * total_distance
  end

  def self.go_back_from_order(input, stores, store_number, order)
    puts 'If you go back, the list of orders will disappear'
    while input != 'y' && input != 'n'
      puts 'Are You Sure?(y/n)'
      input = STDIN.gets.chomp
    end
    if input == 'y'
      order_food(stores)
    else
      choose_menu(stores, store_number, order)
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

  def self.view_history
    if File.exist?('data/history.txt')
      file = File.open('data/history.txt', 'r')
      file.each_line(&method(:puts))
      file.close
    else
      puts 'Not A Single Order Was Made'
    end
  end

  def self.drivers_check(drivers)
    drivers_temp = []
    drivers.each do |driver|
      drivers_temp.push(driver) if driver.rating.to_f >= 3 || driver.rating.to_f.zero?
    end
    drivers_temp.each do |driver|
      driver.position = [rand(1..20), rand(1..20)]
    end
    return drivers_temp unless drivers_temp.empty?

    file = File.open('default_data.json', 'r')
    data = JSON.parse(file.read)
    file.close
    drivers = data['drivers']
    drivers.each do |driver|
      driver = Driver.new(driver['name'],
                          [rand(1..20), rand(1..20)],
                          0)
      drivers_temp.push(driver)
      return drivers_temp
    end
  end
end
