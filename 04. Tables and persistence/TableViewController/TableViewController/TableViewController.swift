//
//  TableViewController.swift
//  TableViewController
//
//  Created by Román Martínez on 3/9/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
	
	
	// UITableViewController
	// ------------------------------
	// You can have this view controller on its own, but you'll most likely want it to be the root view of a navigation controller
	// so users can navigate to a details screen when they click on a table row, or enable editing of the table elements
	
	
	// UITableView
	// ------------------------------
	// Is added automatically to the view controller, you define the general settings for the table itself, including:
	// - whether the table content is static or dynamic
	// - for dynamic tables, how many prototype cells (content templates) you need
	// - styling settings
	// - scroll settings
	// etc…
	
	
	// UITableViewCell
	// ------------------------------
	// Is included automatically on the table view, you define the settings for individual table cells here
	// if you defined the table cells to be dynamic, you must set a unique "Identifier" name for them on the Attributes Inspector
	
	
	// Content View (UIView)
	// ------------------------------
	// Is included automatically on the table view cell, the actual contents of a cell will be added inside this element
	// The UITableViewCell has a "style" attribute where you can select from 4 preset layouts for the content
	// these have the advantage that the content elements will already be available on the cell element as default properties
	// if you decide to use a fully customized table cell then you'll need to manually set it up, style it, and add the necessary outlets
	
	
	// General settings
	// ------------------------------
	override func viewDidLoad() {
		super.viewDidLoad()
		// Preserve selection between presentations
		self.clearsSelectionOnViewWillAppear = false
		// Display an "Edit" button in the navigation bar
		self.navigationItem.rightBarButtonItem = self.editButtonItem
	}
	
	
	// Populating the table with data
	// ------------------------------
	var data = TableData()
	
	// Sections
	override func numberOfSections(in tableView: UITableView) -> Int {
		return data.meals.count
	}
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String {
		return data.meals[section].name
	}
	
	// Rows/cells
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return data.meals[section].food.count
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableCell", for: indexPath)
		let meal = data.meals[indexPath.section]
		let food = meal.food[indexPath.row]
		cell.textLabel?.text = food.name
		cell.detailTextLabel?.text = food.description
		return cell
	}
}
