//
//  EmojiTableViewCell.swift
//  EmojiDictionary
//
//  Created by Roman Martinez on 22/09/2017.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import UIKit

class EmojiTableViewCell: UITableViewCell {
	
	@IBOutlet weak var symbolLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	
	func update(with emoji: Emoji) {
		symbolLabel.text = emoji.symbol
		nameLabel.text = emoji.name
		descriptionLabel.text = emoji.description
	}
	
}
