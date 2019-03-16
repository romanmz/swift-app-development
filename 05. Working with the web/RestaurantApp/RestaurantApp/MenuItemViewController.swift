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
	var menuItem: MenuItem! {
		didSet {
			updateUI()
		}
	}
	let placeholderImage = UIImage(named: "Placeholder")
	@IBOutlet weak var mainImage: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var categoryLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var addToOrderButton: UIButton!
	
	
	// Initialize
	// ------------------------------
	override func viewDidLoad() {
		super.viewDidLoad()
		NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: MenuData.menuUpdatedNotification, object: nil)
		updateUI()
	}
	@objc func updateUI() {
		// Check that view has been loaded (for when this is triggered by a notification or segue)
		// and also that "menuItem" has already been defined (for when state restoration is still pending)
		guard isViewLoaded, menuItem != nil else { return }
		
		// View
		navigationItem.title = menuItem.name
		addToOrderButton.layer.cornerRadius = 5.0
		
		// Item details
		nameLabel.text = menuItem.name
		priceLabel.text = menuItem.formattedPrice
		categoryLabel.text = menuItem.category.capitalized
		descriptionLabel.text = menuItem.description
		
		// Photo
		mainImage.image = placeholderImage
		MenuData.fetchImage(url: menuItem.imageURL) {
			image in
			DispatchQueue.main.async {
				guard let image = image else {
					self.errorAlert(title: "Network error", message: "There was an error while trying to load the image from \(self.menuItem.imageURL)")
					return
				}
				self.mainImage.image = image
			}
		}
	}
	
	
	// User actions
	// ------------------------------
	@IBAction func addToOrderButtonTapped(_ sender: UIButton) {
		UIView.animate(withDuration: 0.3) {
			self.addToOrderButton.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
			self.addToOrderButton.transform = CGAffineTransform.identity
		}
		MenuData.order.menuItems.append(menuItem)
	}
	
	
	// State preservation
	// ------------------------------
	override func encodeRestorableState(with coder: NSCoder) {
		super.encodeRestorableState(with: coder)
		coder.encode(menuItem.id, forKey: "menuItemId")
	}
	override func decodeRestorableState(with coder: NSCoder) {
		super.decodeRestorableState(with: coder)
		let id = Int(coder.decodeInt32(forKey: "menuItemId"))
		guard let menuItem = MenuData.getMenuItem(withID: id) else { return }
		self.menuItem = menuItem
	}
	
	
}
