//
//  TableViewCell.swift
//  TableViewController
//
//  Created by Román Martínez on 3/9/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
	
	
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
	
	
	// Initialization code
	// ------------------------------
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	
	// Configure the view for the selected state
	// ------------------------------
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}
	
	
	// Populate content
	// ------------------------------
	@IBOutlet weak var symbolLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	func populate(with data: TableRow) {
		symbolLabel.text = data.symbol
		titleLabel.text = data.name
		descriptionLabel.text = data.description
	}
}
