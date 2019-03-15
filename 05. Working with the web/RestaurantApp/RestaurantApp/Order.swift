//
//  Order.swift
//  RestaurantApp
//
//  Created by Román Martínez on 3/15/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import Foundation
import UIKit


// Order
// ------------------------------
struct Order: Codable {
	
	// Order info
	var menuItems: [MenuItem] = []
	var totalCost: Double {
		return menuItems.reduce(0) { $0 + $1.price }
	}
	var formattedTotalCost: String {
		return String(format: "$%.2f", totalCost)
	}
	
	// Submitting an order
	func getSubmitAlert(callback: @escaping (Int?)->Void) -> UIAlertController {
		let alert = UIAlertController(title: "Confirm Order", message: "You are about to submit your order with a total of \(formattedTotalCost)", preferredStyle: .alert)
		let submitAction = UIAlertAction(title: "Submit", style: .default) { alertAction in self.requestTimeEstimate(callback: callback) }
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		alert.addAction(submitAction)
		alert.addAction(cancelAction)
		return alert
	}
	func requestTimeEstimate(callback: @escaping (Int?)->Void) {
		MenuData.submitOrder(order: MenuData.order, completion: callback)
	}
}


// Preparation time (for remote responses)
// ------------------------------
struct PreparationTime: Codable {
	let prepTime: Int
	enum CodingKeys: String, CodingKey {
		case prepTime = "preparation_time"
	}
}
