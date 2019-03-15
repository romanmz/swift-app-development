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
	
	
	// Populate content
	// ------------------------------
	func update(with menuItem: MenuItem, at indexPath: IndexPath, in view: UITableViewController) {
		
		// Update labels
		textLabel?.text = menuItem.name
		detailTextLabel?.text = menuItem.formattedPrice
		imageView?.image = placeholderImage
		
		// Load image
		MenuData.fetchImage(url: menuItem.imageURL) {
			image in
			guard let image = image,
				view.tableView.indexPath(for: self) == indexPath else { return }
			DispatchQueue.main.async {
				self.imageView?.image = image
				self.setNeedsLayout()
			}
		}
	}
	
	
}
