//
//  MenuItem.swift
//  Restaurant
//
//  Created by Roman Martinez on 28/9/17.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import Foundation

struct MenuItems: Codable {
	let items: [MenuItem]
}
struct MenuItem: Codable {
	let id: Int
	let name: String
	let description: String
	let price: Double
	let category: String
	let imageURL: URL
	
	enum CodingKeys: String, CodingKey {
		case id
		case name
		case description
		case price
		case category
		case imageURL = "image_url"
	}
}
