//
//  ViewController.swift
//  TabBarController
//
//  Created by Román Martínez on 3/6/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	
	// Example: Clear the badge after 1 second of viewing the view
	// ------------------------------
	var badgeToBeCleared = false
	override func viewDidAppear(_ animated: Bool) {
		badgeToBeCleared = true
		DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: clearBadge)
	}
	override func viewWillDisappear(_ animated: Bool) {
		badgeToBeCleared = false
	}
	func clearBadge() {
		if badgeToBeCleared {
			self.tabBarItem.badgeValue = nil
		}
	}
	
	
}
