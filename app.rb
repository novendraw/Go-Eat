# frozen_string_literal: true

$LOAD_PATH << '.'

require 'src/module/view_history'
require 'src/module/order_food'
require 'src/module/show_map'
require 'src/class/user'
require 'src/class/store'
require 'src/class/food'
require 'src/class/driver'
require 'json'

UNIT_COST = 300

map_size = 20
map_coordinates = Hash.new(' -')
stores = []
stores_temp = []
drivers = []
drivers_temp = []
user = []
input_array = ARGV
case input_array.size
when 0
  file = File.open('data/default_data.json', 'r')
  data = JSON.parse(file.read)
  file.close
  stores = data['stores']
  drivers = data['drivers']
  drivers.each do |driver|
    driver = Driver.new(driver['name'],
                        [rand(1..20), rand(1..20)],
                        0)
    map_coordinates[driver.position] = ' D'
    drivers_temp.push(driver)
  end
  drivers = drivers_temp
  stores.each do |store|
    menu = []
    store['menu'].each do |food|
      food = Food.new(food['name'],
                      food['price'], 0)
      menu.push(food)
    end
    store = Store.new(store['name'],
                      [rand(1..20), rand(1..20)],
                      menu)
    map_coordinates[store.position] = ' S'
    stores_temp.push(store)
  end
  stores = stores_temp
  user = User.new([rand(1..20), rand(1..20)], [])
  map_coordinates[user.position] = ' U'
when 3
  map_size = input_array[0].to_i
  file = File.open('data/default_data.json', 'r')
  data = JSON.parse(file.read)
  file.close
  stores = data['stores']
  drivers = data['drivers']
  drivers.each do |driver|
    driver = Driver.new(driver['name'],
                        [rand(1..20), rand(1..20)],
                        0)
    map_coordinates[driver.position] = ' D'
    drivers_temp.push(driver)
  end
  drivers = drivers_temp
  stores.each do |store|
    menu = []
    store['menu'].each do |food|
      food = Food.new(food['name'],
                      food['price'], 0)
      menu.push(food)
    end
    store = Store.new(store['name'],
                      [rand(1..20), rand(1..20)],
                      menu)
    map_coordinates[store.position] = ' S'
    stores_temp.push(store)
  end
  stores = stores_temp
  user = User.new([input_array[1].to_i, input_array[2].to_i], [])
  map_coordinates[user.position] = ' U'
when 1
  file = File.open("data/#{input_array[0]}", 'r')
  data = JSON.parse(file.read)
  file.close

  map_size = data['map_size']
  stores = data['stores']
  drivers = data['drivers']
  drivers.each do |driver|
    position = driver['position'].split(' ')
    driver = Driver.new(driver['name'],
                        [position[0].to_i, position[1].to_i],
                        0)
    map_coordinates[driver.position] = ' D'
    drivers_temp.push(driver)
  end
  drivers = drivers_temp
  stores.each do |store|
    menu = []
    position = store['position'].split(' ')
    store['menu'].each do |food|
      food = Food.new(food['name'],
                      food['price'], 0)
      menu.push(food)
    end
    store = Store.new(store['name'],
                      [position[0].to_i, position[1].to_i],
                      menu)
    map_coordinates[store.position] = ' S'
    stores_temp.push(store)
  end
  stores = stores_temp
  position = data['user_position'].split(' ')
  user = User.new([position[0].to_i, position[1].to_i], [])
  map_coordinates[user.position] = ' U'
else
  puts 'Wrong number of argument(s)'
end

command = ''
puts '   _____  ____             ______       _______
  / ____|/ __ \           |  ____|   /\|__   __|
 | |  __| |  | |  ______  | |__     /  \  | |
 | | |_ | |  | | |______| |  __|   / /\ \ | |
 | |__| | |__| |          | |____ / ____ \| |
  \_____|\____/           |______/_/    \_\_|'
puts 'Welcome to Go-Eat, #1 Food Delivery Service Around The World'
while command != '4'
  puts ''
  puts 'What would you like to do?'
  puts '1. Show Map'
  puts '2. Order Food'
  puts '3. View History'
  puts '4. Exit'
  print 'command : '
  command = STDIN.gets.chomp
  case command
  when '1'
    puts 'Maps :'
    ShowMap.show_map(map_size, map_coordinates)
    ShowMap.show_information
    ShowMap.display_stores(stores, 1)
  when '2'
    order_data = OrderFood.order_food(stores)
    order_data = [[]] if order_data.is_a? Integer

    sum = 0
    order_data[0].each do |food|
      sum += food.quantity * food.price
    end
    if sum != 0
      trans_data = [order_data[0],
                    user,
                    stores[order_data[1]],
                    drivers,
                    UNIT_COST,
                    map_size,
                    sum]
      picked_driver = OrderFood.finish_order(trans_data)

      OrderFood.display_routes(user, trans_data[2], drivers[picked_driver])
      drivers[picked_driver].rating = ViewHistory.write_to_history(
        user, trans_data[2], drivers[picked_driver], sum
      )
      drivers = ShowMap.drivers_check(drivers)
    end
  when '3'
    puts 'History :'
    puts ''
    ViewHistory.view_history
  when '4'
    puts ''
    puts 'Goodbye, Thanks for using our service :D'
  else
    puts ''
    puts 'Sorry, you cannot do that'
  end
  map_coordinates = Hash.new(' -')
  drivers.each do |driver|
    map_coordinates[driver.position] = ' D'
  end
  stores.each do |store|
    map_coordinates[store.position] = ' S'
  end
  map_coordinates[user.position] = ' U'
end
