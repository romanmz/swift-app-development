//
//  Data.swift
//  TableViewController
//
//  Created by Román Martínez on 3/9/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import Foundation

struct TableSection: Codable {
	var name: String
	var rows: [TableRow]
}
struct TableRow: Codable {
	var symbol: String
	var name: String
	var description: String
}
struct TableData: Codable {
	var sections: [TableSection]
	
	// Sample data
	static var sampleData: TableData {
		return TableData(sections: [
			TableSection(name: "Breakfast", rows:[
				TableRow(symbol: "😀", name:"Cereal", description:"sweet!"),
				TableRow(symbol: "😕", name:"Fruit", description:"healthy!"),
				TableRow(symbol: "😍", name:"Toast", description:"yummy!"),
			]),
			TableSection(name: "Lunch", rows:[
				TableRow(symbol: "👮", name:"Steak", description:"protein!"),
				TableRow(symbol: "🐢", name:"Laksa", description:"warm!"),
				TableRow(symbol: "🐘", name:"Spagetthi", description:"delicious!"),
			]),
			TableSection(name: "Dinner", rows:[
				TableRow(symbol: "🍝", name:"Sandwich", description:"meh"),
				TableRow(symbol: "🎲", name:"Chocolate", description:"unhealthy!"),
				TableRow(symbol: "⛺️", name:"Tacos", description:"yum!"),
			]),
		])
	}
}
