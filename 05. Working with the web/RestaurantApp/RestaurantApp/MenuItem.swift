//
//  Menu.swift
//  RestaurantApp
//
//  Created by Román Martínez on 3/14/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import Foundation


// Menu items (for remote responses)
// ------------------------------
struct MenuItems: Codable {
	let items: [MenuItem]
}


// Menu item
// ------------------------------
struct MenuItem: Codable {
	let id: Int
	let name: String
	let description: String
	let price: Double
	let category: String
	let imageURL: URL
	var formattedPrice: String {
		return String(format: "$%.2f", self.price)
	}
	enum CodingKeys: String, CodingKey {
		case id
		case name
		case description
		case price
		case category
		case imageURL = "image_url"
	}
}
