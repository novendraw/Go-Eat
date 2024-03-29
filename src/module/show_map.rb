# frozen_string_literal: true

# Show Map Director
# module for show_map command
module ShowMap
  def self.show_map(size, map)
    i = 1
    while i <= size
      j = 1
      while j <= size
        print map[[j, i]]
        j += 1
      end
      puts ''
      i += 1
    end
  end

  # display available store and its location
  def self.display_stores(stores, iterator)
    while iterator <= stores.size
      data = stores[iterator - 1]
      puts "#{iterator}. #{data.name}(#{data.position[0]},#{data.position[1]})"
      iterator += 1
    end
  end

  # do driver's rating check before assigned to map coordinates
  def self.drivers_check(drivers)
    drivers_temp = []
    drivers.each do |driver|
      drivers_temp.push(driver) if driver.rating.to_f >= 3 || driver.rating.to_f.zero?
    end
    drivers_temp.each do |driver|
      driver.position = [rand(1..20), rand(1..20)]
    end
    return drivers_temp unless drivers_temp.empty?

    puts 'Looking For Driver'
    file = File.open('data/default_data.json', 'r')
    data = JSON.parse(file.read)
    file.close
    drivers = data['drivers']
    drivers.each do |driver|
      driver = Driver.new(driver['name'],
                          [rand(1..20), rand(1..20)],
                          0)
      drivers_temp.push(driver)
    end
    drivers_temp
  end

  # show map information
  def self.show_information
    puts 'Information :'
    puts 'Top Left is (1,1) and Bottom Right is (20,20)'
    puts 'U = User'
    puts 'D = Driver'
    puts 'S = Store'
    puts 'Store Location :'
  end
end
