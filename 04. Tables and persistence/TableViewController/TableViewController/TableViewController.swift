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
	
	
	// General settings
	// ------------------------------
	var data: TableData! {
		didSet {
			TableData.saveToFile(data: data)
		}
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Load saved data
		data = self.loadInitialData()
		
		// Preserve selection between presentations
		clearsSelectionOnViewWillAppear = false
		
		// Display an "Edit" button in the navigation bar
		navigationItem.leftBarButtonItem = self.editButtonItem
		
		// Auto-height for rows
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 54.0
	}
	
	
	// Populating the table with data
	// ------------------------------
	
	// Sections
	override func numberOfSections(in tableView: UITableView) -> Int {
		return data.sections.count
	}
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String {
		return data.sections[section].name
	}
	
	// Rows/cells
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return data.sections[section].rows.count
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableCell", for: indexPath) as! TableViewCell
		let cellData = data.sections[indexPath.section].rows[indexPath.row]
		cell.populate(with: cellData)
		return cell
	}
	
	
	// Moving items around
	// ------------------------------
	
	// Enable on individual items
	override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	// Restrict where items can be moved to, in this example they can't be moved out of their current section
	override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
		if sourceIndexPath.section != proposedDestinationIndexPath.section {
			return sourceIndexPath
		}
		return proposedDestinationIndexPath
	}
	
	// Move item
	override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
		let movedRow = data.sections[fromIndexPath.section].rows.remove(at: fromIndexPath.row)
		data.sections[to.section].rows.insert(movedRow, at: to.row)
		tableView.reloadData()
	}
	
	
	// Deleting/inserting items
	// ------------------------------
	
	// Enable on individual items
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	// Define what kind of editing users can do on an item: .none, .insert or .delete
	override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		return .delete
	}
	
	// Edit item
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			data.sections[indexPath.section].rows.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .fade)
		} else if editingStyle == .insert {
			// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
		}
	}
	
	
	// Moving to/from item data editing screen
	// ------------------------------
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// newTableRow
		if segue.identifier == "editTableRow" {
			guard let selectedCell = tableView.indexPathForSelectedRow,
				let editScreen = segue.destination as? EditScreenViewController else { return }
			let selectedRow = data.sections[selectedCell.section].rows[selectedCell.row]
			editScreen.row = selectedRow
		}
	}
	@IBAction func unwindToTableData(segue: UIStoryboardSegue) {
		// cancelEditing
		if segue.identifier == "saveEditing" {
			guard let editScreen = segue.source as? EditScreenViewController,
				let row = editScreen.row else { return }
			if let selectedRow = tableView.indexPathForSelectedRow {
				// existing item
				data.sections[selectedRow.section].rows[selectedRow.row] = row
				tableView.reloadRows(at: [selectedRow], with: .none)
			} else {
				// new item
				let lastSection = data.sections.count - 1
				let newRow = data.sections[lastSection].rows.count
				let index = IndexPath(row: newRow, section: lastSection)
				data.sections[lastSection].rows.append(row)
				tableView.insertRows(at: [index], with: .automatic)
			}
		}
	}
	
	
}
