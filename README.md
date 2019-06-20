# Go - Eat
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

**Go - Eat** is a command line app. The app consists of drivers, stores, and a user. Every driver rated in the form of decimal number in the range of 0.0 to 5.0 and they will initially have 0 point of rating when the program runs for the first time. Each store has a menu which consists of item(s). The map which the user, drivers, and stores are placed on will be generated randomly and guaranteed that there is at least a path that can be taken for each driver to go to every store before finally proceeding to the user.

## Installation

You need **ruby** to run this program. Please go to [ruby's website](https://www.ruby-lang.org) if you haven't installed it.

Install this app locally :

```
git clone https://github.com/novendraw/Go-Eat
```

## Execution

Go-Eat can be executed in three ways :

### By running the app without any arguments
The app will generate a random 20*20 map, put 5 drivers, 3 stores, and one user, each at a random coordinate. Each store is already provided with a default store name and item(s) name and price available in the menu. example :
> ruby app.rb

### By running the app with three arguments
The first argument (n, for instance) would be the size of the generated map (n * n). The second and the third argument (x and y, respectively) would be the coordinate of the user (x, y). The app still generate 5 drivers and 3 stores and put them randomly on the map. example :
> ruby app.rb 20 5 4

### By passing a filename as an argument
The app will generate a random map with its size specified in the file, user wil be put in the coordinate specified in the file. Drivers and stores (complete with store name and menu), will be put in their coordinate specified in the file as well. Currently supported file type is JSON, with data format as specified below. example :
> ruby app.rb example_data.json
> (file must placed in `data` folder)

## Usage

Once the app is running, user will be prompted choices of action :
### Show Map
The app will display the map and show where the user, drivers, and stores are.
### Order Food
The app will ask the user’s store of choice. It will first display the name of the stores and ask for the user’s input in order to choose a store. Next, the app will display the store’s available item(s) along with its price. User should input the item name/number along with the amount of the item. The app also give the user a choice to add more items or finish the order. After finishing the order, the app will display the item(s) ordered, the amount for each item, and the total price for the order. Next, the app will display the routes taken by the driver to both buy the item(s) from the store of choice and also reach the user after.
Once the order is completed, user should give the driver a rating ranging from 1 to 5 using input. A particular driver should have an average rating of 3 or more, otherwise that driver will be removed from the map. If at one point every driver in the map is removed, "Looking For Driver" message will show. After that, the app will generate new drivers at random positions. Finally, the information of driver's name, route, name of store, item(s) ordered, and price is stored in a text file saved in the `data` folder as `history_with_routes.txt`. 

### View History
The app will display all orders history of the user from a file in `data` folder saved as `history.txt`. Each order history contains the name of the store, the menu(s) ordered, and the total payment of the order. If no history is recorded yet, the app will display nothing or return "Not A Single Order Was Made".

## Data Format

The following is an example of data format :

```
{
  "map_size" : 20,
  "user_position" : "4 4",
  "drivers" :
  [
    {"name" : "Nadam Mekram",
     "position" : "5 1"},
    {"name" : "Anji Girl",
     "position" : "1 6"},
    {"name" : "Michelle Marn",
     "position" : "1 5"},
    {"name" : "Kafn Awl",
     "position" : "1 4"},
    {"name" : "Manca Odwang",
     "position" : "1 3"}
  ],
  "stores" :
  [
    {"name" : "GoGo Canteen",
     "position" : "1 1",
     "menu" :
     [
       {
         "name" : "Sliced Bug with Stack Overflow Sauce",
         "price" : 131010
       }
     ]}
  ]
}
```

This data format example also available in `data` folder as `example_data.json`.

## Application Design

In this project, I use the **Builder** and  **State** design pattern.

> Builder is a creational design pattern that lets you construct complex objects step by step. The pattern allows you to produce different types and representations of an object using the same construction code. - refactoring.guru

> State is a behavioral design pattern that lets an object alter its behavior when its internal state changes. It appears as if the object changed its class. - refactoring.guru

The `app.rb` works as builder, and the three modules (`show_map.rb`, `order_food.rb`, and `view_history.rb`) works as director in the **builder design pattern**.

Each module is built using **state design pattern**.

I choose the **builder design pattern** because I want the app to works with a goal to **build** the information that will given to the user.

I choose the **state design pattern** because as the director, I want the *three modules* 
to give decision from its current state, not the whole program, so the variation of the decision depends on its current state.

I choose the **JSON** data format for the input file because :

+ Made in text format which is language independent and can be run everywhere.
+ There is already a JSON parser in ruby.
+ Designed such that humans can easily read data interchange and its execution.

I choose the **txt** filetype for the history file because the history file is read-only, so it doesn't need a complex document file format.

## Author

__Eka Novendra Wahyunadi__

## License

Copyright (c) Eka Novendra Wahyunadi. All rights reserved.

Licensed under the [GNU GPLv3](https://github.com/novendraw/Go-Eat/blob/master/LICENSE) license.
