//
//  ResultsViewController.swift
//  PersonalityQuiz
//
//  Created by Román Martínez on 3/7/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
	
	
	// Properties
	// ------------------------------
	var result: AnimalType!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	
	
	// Load view
	// ------------------------------
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Disable "back" button
		navigationItem.hidesBackButton = true
		
		// Update content
		titleLabel.text = "You are a \(result.rawValue)"
		descriptionLabel.text = result.definition
	}
	
	
}
