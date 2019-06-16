# frozen_string_literal: true

$LOAD_PATH << '.'

require 'action'
require 'user'
require 'store'
require 'food'
require 'driver'
require 'json'

UNIT_COST = 300

map_size = 20
map_coordinates = Hash.new(' -')
stores = []
stores_temp = []
drivers = []
drivers_temp = []
user = []

case ARGV.length
when 0
  file = File.open('default_data.json', 'r')
  data = JSON.parse(file.read)
  file.close
  stores = data['stores']
  drivers = data['drivers']
  drivers.each do |driver|
    driver = Driver.new(driver['name'],
                        [rand(1..20), rand(1..20)],
                        driver['rating'])
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
when 1
  file = File.open(ARGV[0], 'r')
  data = JSON.parse(file.read)
  file.close

  map_size = data['map_size']
  stores = data['stores']
  drivers = data['drivers']
  drivers.each do |driver|
    position = driver['position'].split(' ')
    driver = Driver.new(driver['name'],
                        [position[0].to_i, position[1].to_i],
                        driver['rating'])
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
puts 'Welcome to Go-Eat, #1 Food Delivery Service Around The World'
while command != '4'
  puts 'What would you like to do?'
  puts '1. Show Map'
  puts '2. Order Food'
  puts '3. View History'
  puts '4. Exit'
  command = gets.chomp
  case command
  when '1'
    Action.show_map(map_size, map_coordinates)
  when '2'
    order_data = Action.order_food(stores)
    sum = 0
    order_data[0].each do |food|
      sum += food.quantity * food.price
    end
    finish_order_data = [order_data[0],
                         user,
                         stores[order_data[1]],
                         drivers,
                         UNIT_COST,
                         map_size,
                         sum]
    Action.finish_order(finish_order_data)
  when '3'
    Action.view_history
  when '4'
    puts 'Goodbye, Thanks for using our service :D'
  else
    puts 'Sorry, you cannot do that'
  end

end
