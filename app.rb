# frozen_string_literal: true

$LOAD_PATH << '.'

require 'action'
require 'user'
require 'store'
require 'food'
require 'driver'
require 'json'

map_size = 20
map_coordinates = Hash.new(' -')
stores = []
stores_temp = []
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
  end

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
  end

  stores.each do |store|
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
    menu = []
  end

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
  command = gets.chomp
  case command
  when '1'
    Action.show_map(map_size, map_coordinates)
  when '2'
    Action.order_food
  when '3'
    Action.view_history
  when '4'
    puts 'Goodbye, Thanks for using our service :D'
  else
    puts 'Sorry, you cannot do that'
  end

end
