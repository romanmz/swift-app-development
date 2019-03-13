//
//  ListItemCell.swift
//  ComplexInputScreens
//
//  Created by Román Martínez on 3/11/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit

class ListItemCell: UITableViewCell {
	
	
	// Populate content
	// ------------------------------
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var priorityLabel: UILabel!
	@IBOutlet weak var amountLabel: UILabel!
	@IBOutlet weak var toggleButton: UIButton!
	@IBOutlet weak var toggleLabel: UILabel!
	func update(with item: ListItem) {
		titleLabel.text = item.title
		dateLabel.text = "Date: \(item.readableDate)"
		priorityLabel.text = "Description: \(item.priority.description)"
		amountLabel.text = "Amount: \(item.amount)"
		toggleButton.isSelected = item.toggle
		toggleLabel.text = "Toggle: \(item.toggle ? "✓" : "×")"
	}
	
	
	// Toggle button pressed
	// ------------------------------
	var delegate: ListItemCellDelegate?
	@IBAction func toggleButtonPressed(_ sender: UIButton) {
		delegate?.toggleDidChange(toggle: sender, cell: self)
	}
}
protocol ListItemCellDelegate {
	func toggleDidChange(toggle: UIButton, cell: ListItemCell)
}
