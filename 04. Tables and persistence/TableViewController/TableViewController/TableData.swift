//
//  Data.swift
//  TableViewController
//
//  Created by Román Martínez on 3/9/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import Foundation


struct Meal {
	var name: String
	var food: [Food]
}
struct Food {
	let name: String
	let description: String
}
struct TableData {
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
}
