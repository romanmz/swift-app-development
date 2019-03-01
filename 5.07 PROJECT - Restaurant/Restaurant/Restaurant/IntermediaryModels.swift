//
//  IntermediaryModels.swift
//  Restaurant
//
//  Created by Roman Martinez on 28/9/17.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import Foundation

struct Categories: Codable {
	let categories: [String]
}

struct PreparationTime: Codable {
	let prepTime: Int
	
	enum CodingKeys: String, CodingKey {
		case prepTime = "preparation_time"
	}
}

struct Order: Codable {
    var menuItems: [MenuItem]
    
    init(menuItems: [MenuItem] = []) {
        self.menuItems = menuItems
    }
}
