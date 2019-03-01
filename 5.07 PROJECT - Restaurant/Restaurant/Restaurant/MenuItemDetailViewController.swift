//
//  MenuItemDetailViewController.swift
//  Restaurant
//
//  Created by Roman Martinez on 28/9/17.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import UIKit


protocol AddToOrderDelegate {
	func added(item: MenuItem)
}


class MenuItemDetailViewController: UIViewController {
	
	
	// Properties
	// ------------------------------
	var menuItem: MenuItem!
	var delegate: AddToOrderDelegate?
	
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
		setupDelegate()
        addButton.layer.cornerRadius = 5.0
		updateUI()
    }
	func setupDelegate() {
		guard let navController = tabBarController?.viewControllers?.last as? UINavigationController,
			let orderController = navController.viewControllers.first as? OrderTableViewController else { return }
		self.delegate = orderController
	}
	func updateUI() {
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
		delegate?.added(item: menuItem)
		UIView.animate(withDuration: 0.3) {
			self.addButton.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
			self.addButton.transform = CGAffineTransform.identity
		}
	}
	
	
}
