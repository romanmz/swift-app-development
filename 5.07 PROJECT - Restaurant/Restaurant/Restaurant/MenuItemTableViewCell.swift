//
//  MenuItemTableViewCell.swift
//  Restaurant
//
//  Created by Roman Martinez on 29/9/17.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import UIKit

class MenuItemTableViewCell: UITableViewCell {
	
	
	// Properties
	// ------------------------------
	let defaultImage = UIImage(imageLiteralResourceName: "gray")
	@IBOutlet weak var photoView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var priceLabel: UILabel!
	
	
	// Methods
	// ------------------------------
	func update(with menuItem: MenuItem, at indexPath: IndexPath, in viewController: UITableViewController) {
		titleLabel.text = menuItem.name
		priceLabel.text = String(format: "$%.2f", menuItem.price)
		NetworkRequests.shared.fetchImage(url: menuItem.imageURL) { (image) in
			guard viewController.tableView.indexPath(for: self) == indexPath else { return }
			if let image = image {
				self.photoView.image = image
			} else {
				self.photoView.image = self.defaultImage
			}
		}
	}
	
	
}
