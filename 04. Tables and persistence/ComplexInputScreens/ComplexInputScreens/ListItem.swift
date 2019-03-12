//
//  ItemsData.swift
//  ComplexInputScreens
//
//  Created by Román Martínez on 3/11/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import Foundation

struct ListItem {
	var title: String = ""
	var date: Date = Date()
	var priority: ListItemPriority = .low
	var amount: Int = 1
	var toggle: Bool = false
	
	var readableDate: String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .none
		return dateFormatter.string(from: self.date)
	}
}
enum ListItemPriority: CustomStringConvertible {
	case low, medium, high
	static let all: [ListItemPriority] = [.low, .medium, .high]
	var description: String {
		switch self {
		case .low:
			return "Low Priority"
		case .medium:
			return "Medium Priority"
		case .high:
			return "High Priority"
		}
	}
}
