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
    input = gets.chomp.to_i
    order_food(stores) if input > (stores.size + 1) || input < 1
    return if input == stores.size + 1

    store_number = input - 1
    choose_menu(stores, store_number, stores[store_number].menu)
  end

  def self.choose_menu(stores, store_number, order)
    count_menu = stores[store_number].menu.size
    stores[store_number].display_menu(count_menu)
    input = gets.chomp.to_i
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
      puts 'finish order'
    else
      add_order(input - 1, order, stores, store_number)
    end
  end

  def self.confirm_order(stores, store_number, order)
    puts '1. Add More Items'
    puts '2. Finish Order'
    input = gets.chomp.to_i
    confirm_order(stores, store_number, order) while input != 1 && input != 2
    if input == 1
      choose_menu(stores, store_number, order)
    else
      finish_order(order)
    end
  end

  def self.finish_order(order)
    order.each(&:display_ordered_items)
  end

  def self.go_back_from_order(input, stores, store_number, order)
    puts 'If you go back, the list of orders will disappear'
    while input != 'y' && input != 'n'
      puts 'Are You Sure?(y/n)'
      input = gets.chomp
    end
    if input == 'y'
      order_food(stores)
    else
      choose_menu(stores, store_number, order)
    end
  end

  def self.view_history
    puts 'here'
  end
end
