//
//  Registration.swift
//  HotelManzana
//
//  Created by Roman Martinez on 26/9/17.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import Foundation

struct Registration {
	let firstName: String
	let lastName: String
	let emailAddress: String
	
	let checkInDate: Date
	let checkOutDate: Date
	let numberOfAdults: Int
	let numberOfChildren: Int
	
	let roomType: RoomType
	let wifi: Bool
	
	static func getFormattedDate(_ date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .none
		return dateFormatter.string(from: date)
	}
}
