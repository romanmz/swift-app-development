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
	func update(with item: ListItem) {
		titleLabel.text = item.title
		dateLabel.text = "Date: \(item.readableDate)"
		priorityLabel.text = "Description: \(item.priority.description)"
	}
	
	
}
