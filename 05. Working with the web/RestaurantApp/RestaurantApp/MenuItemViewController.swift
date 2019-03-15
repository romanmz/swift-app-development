//
//  MenuItemViewController.swift
//  RestaurantApp
//
//  Created by Román Martínez on 3/15/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit

class MenuItemViewController: UIViewController {
	
	
	// Properties
	// ------------------------------
	var menuItem: MenuItem!
	let placeholderImage = UIImage(named: "Placeholder")
	@IBOutlet weak var mainImage: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var categoryLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	
	
	// Initialize
	// ------------------------------
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = menuItem.name
		NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: MenuData.menuUpdatedNotification, object: nil)
		updateUI()
	}
	@objc func updateUI() {
		nameLabel.text = menuItem.name
		priceLabel.text = menuItem.formattedPrice
		categoryLabel.text = menuItem.category.capitalized
		descriptionLabel.text = menuItem.description
		mainImage.image = placeholderImage
		MenuData.fetchImage(url: menuItem.imageURL) {
			image in
			guard let image = image else { return }
			DispatchQueue.main.async {
				self.mainImage.image = image
			}
		}
	}
	
	
}
