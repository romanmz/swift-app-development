//
//  ToDoCell.swift
//  ToDoList
//
//  Created by Roman Martinez on 27/9/17.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import UIKit

protocol ToDoCellDelegate: class {
	func checkmarkTapped(sender: ToDoCell)
}

class ToDoCell: UITableViewCell {
	
	var delegate: ToDoCellDelegate?
	@IBOutlet weak var isCompleteButton: UIButton!
	@IBOutlet weak var titleLabel: UILabel!
	
	@IBAction func completeButtonTapped(_ sender: UIButton) {
		delegate?.checkmarkTapped(sender: self)
	}
}
