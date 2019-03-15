//
//  ConfirmationViewController.swift
//  RestaurantApp
//
//  Created by Román Martínez on 3/15/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit

class ConfirmationViewController: UIViewController {
	
	
	// Populate content
	// ------------------------------
	var prepTime: Int!
	@IBOutlet weak var confirmationMessageLabel: UILabel!
	override func viewDidLoad() {
		super.viewDidLoad()
		confirmationMessageLabel.text = "Your order will be ready in \(prepTime!) minutes"
	}
	
	
}
