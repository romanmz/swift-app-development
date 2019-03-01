//
//  MenuItemDetailViewController.swift
//  Restaurant
//
//  Created by Roman Martinez on 28/9/17.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import UIKit


class MenuItemDetailViewController: UIViewController {
	
	
	// Properties
	// ------------------------------
	var menuItem: MenuItem?
	
	// Outlets
	@IBOutlet weak var photoView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var categoryLabel: UILabel!
	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var addButton: UIButton!
	
	
	// Methods
	// ------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.layer.cornerRadius = 5.0
		updateUI()
    }
	override func encodeRestorableState(with coder: NSCoder) {
		super.encodeRestorableState(with: coder)
		guard let menuItem = menuItem else { return }
		coder.encode(menuItem.id, forKey: "menuItemId")
	}
	override func decodeRestorableState(with coder: NSCoder) {
		super.decodeRestorableState(with: coder)
		let menuItemId = Int(coder.decodeInt32(forKey: "menuItemId"))
		menuItem = MenuController.shared.item(withID: menuItemId)!
		updateUI()
	}
	func updateUI() {
		guard let menuItem = menuItem else { return }
		nameLabel.text = menuItem.name
		categoryLabel.text = menuItem.category.capitalized
		priceLabel.text = String(format: "$%.2f", menuItem.price)
		descriptionLabel.text = menuItem.description
		
		// Fetch photo
		photoView.image = nil
		MenuController.shared.fetchImage(url: menuItem.imageURL) { (photo) in
            guard let photo = photo else { return }
            DispatchQueue.main.async {
				self.photoView.image = photo
            }
		}
	}
	
	
	// Actions
	// ------------------------------
	@IBAction func addToOrderButtonTapped(_ sender: UIButton) {
		guard let menuItem = menuItem else { return }
		UIView.animate(withDuration: 0.3) {
			self.addButton.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
			self.addButton.transform = CGAffineTransform.identity
		}
		MenuController.shared.order.menuItems.append(menuItem)
	}
	
	
}
