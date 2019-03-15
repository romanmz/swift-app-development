//
//  MenuItemCell.swift
//  RestaurantApp
//
//  Created by Román Martínez on 3/15/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit

class MenuItemCell: UITableViewCell {
	
	
	// Properties
	// ------------------------------
	let placeholderImage = UIImage(named: "Placeholder")
	@IBOutlet weak var thumbnailImage: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var priceLabel: UILabel!
	
	
	// Populate content
	// ------------------------------
	func update(with menuItem: MenuItem, at indexPath: IndexPath, in view: UITableViewController) {
		
		// Update labels
		thumbnailImage.image = placeholderImage
		nameLabel.text = menuItem.name
		priceLabel.text = menuItem.formattedPrice
		
		// Load image
		MenuData.fetchImage(url: menuItem.imageURL) {
			image in
			DispatchQueue.main.async {
				// Error
				guard let image = image else {
					view.errorAlert(title: "Network error", message: "There was an error while trying to load the image from \(menuItem.imageURL)")
					return
				}
				// Since this is an asynchronous call, we need to ensure we're still modifying the correct cell
				guard view.tableView.indexPath(for: self) == indexPath else { return }
				self.thumbnailImage.image = image
				self.setNeedsLayout()
			}
		}
	}
	
	
}
