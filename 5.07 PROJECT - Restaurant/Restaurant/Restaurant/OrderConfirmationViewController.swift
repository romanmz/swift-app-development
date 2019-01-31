//
//  OrderConfirmationViewController.swift
//  Restaurant
//
//  Created by Roman Martinez on 29/9/17.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import UIKit

class OrderConfirmationViewController: UIViewController {
	
	
	// Properties
	// ------------------------------
	var minutes: Int!
	@IBOutlet weak var timeRemainingLabel: UILabel!
	
	
	// Methods
	// ------------------------------
	override func viewDidLoad() {
        super.viewDidLoad()
		timeRemainingLabel.text = "Your order will be ready in \(minutes!) minutes"
	}
	@IBAction func dismissButtonTapped(_ sender: UIButton) {
	}
	
	
}
