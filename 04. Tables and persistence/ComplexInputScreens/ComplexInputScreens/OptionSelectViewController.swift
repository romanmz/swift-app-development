//
//  OptionSelectViewController.swift
//  ComplexInputScreens
//
//  Created by Román Martínez on 3/11/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit

class OptionSelectViewController: UITableViewController {
	
	
	// Options data
	// ------------------------------
	var options: [CustomStringConvertible] = []
	var selectedOption: CustomStringConvertible? {
		didSet {
			tableView.reloadData()
		}
	}
	
	
	// Populate options
	// ------------------------------
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return options.count
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath)
		let option = options[indexPath.row]
		cell.textLabel?.text = option.description
		if let selectedOption = self.selectedOption, option.description == selectedOption.description {
			cell.accessoryType = .checkmark
		} else {
			cell.accessoryType = .none
		}
		return cell
	}
	
	
	// Select option
	// ------------------------------
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		selectedOption = options[indexPath.row]
	}
}
