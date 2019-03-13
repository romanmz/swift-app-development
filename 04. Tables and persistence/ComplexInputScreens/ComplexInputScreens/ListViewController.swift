//
//  ListViewController.swift
//  ComplexInputScreens
//
//  Created by Román Martínez on 3/11/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController, ListItemCellDelegate {
	
	
	// Populate table content
	// ------------------------------
	var items: [ListItem] = [] {
		didSet {
			tableView.reloadData()
		}
	}
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ListItem", for: indexPath) as! ListItemCell
		let item = items[indexPath.row]
		cell.delegate = self
		cell.update(with: item)
		return cell
	}
	
	
	// Catch events from within cells
	// ------------------------------
	func toggleDidChange(toggle: UIButton, cell: ListItemCell) {
		guard let index = tableView.indexPath(for: cell) else { return }
		var item = items[index.row]
		item.toggle = !item.toggle
		items.remove(at: index.row)
		items.insert(item, at: index.row)
	}
	
	
	// Prepare edit screen
	// ------------------------------
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let editView = segue.destination as? ItemEditViewController else { return }
		if segue.identifier == "editItem", let selectedIndex = tableView.indexPathForSelectedRow {
			let item = items[selectedIndex.row]
			editView.item = item
			editView.navigationItem.title = "Editing item “\(item.title)”"
		} else {
			editView.item = ListItem()
			editView.navigationItem.title = "New item"
		}
	}
	
	
	// Return from edit screen
	// ------------------------------
	@IBAction func unwindToListView(segue: UIStoryboardSegue) {
		guard segue.identifier == "saveEdit",
			let editView = segue.source as? ItemEditViewController,
			let newItem = editView.item else { return }
		if let selectedRow = tableView.indexPathForSelectedRow {
			items[selectedRow.row] = newItem
		} else {
			items.insert(newItem, at: 0)
		}
	}
}
