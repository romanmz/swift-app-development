//
//  FoodTableViewController.swift
//  MealTracker
//
//  Created by Roman Martinez on 22/09/2017.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import UIKit

class FoodTableViewController: UITableViewController {
	
	var meals: [Meal] {
		let breakfast = Meal(name: "Breakfast", food:[
			Food(name:"Cereal", description:"sweet!"),
			Food(name:"Fruit", description:"healthy!"),
			Food(name:"Toast", description:"yummy!"),
		])
		let lunch = Meal(name: "Lunch", food:[
			Food(name:"Steak", description:"protein!"),
			Food(name:"Laksa", description:"warm!"),
			Food(name:"Spagetthi", description:"delicious!"),
		])
		let dinner = Meal(name: "Dinner", food:[
			Food(name:"Sandwich", description:"meh"),
			Food(name:"Chocolate", description:"unhealthy!"),
			Food(name:"Tacos", description:"yum!"),
		])
		return [breakfast, lunch, dinner]
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return meals.count
    }
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals[ section ].food.count
    }
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath)
		let meal = meals[ indexPath.section ]
		let food = meal.food[ indexPath.row ]
		cell.textLabel?.text = food.name
		cell.detailTextLabel?.text = food.description
		return cell
	}
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String {
		return meals[section].name
	}
	
	
}
