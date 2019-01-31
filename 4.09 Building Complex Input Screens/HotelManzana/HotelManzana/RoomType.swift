//
//  RoomType.swift
//  HotelManzana
//
//  Created by Roman Martinez on 26/9/17.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import Foundation

struct RoomType: Equatable {
	let id: Int
	let name: String
	let shortName: String
	let price: Int
	static var all: [RoomType] {
		return [
			RoomType(id: 0, name: "Two Queens", shortName: "2Q", price: 179),
			RoomType(id: 1, name: "One King", shortName: "K", price: 209),
			RoomType(id: 2, name: "Penthouse Suite", shortName: "PHS", price: 309),
		]
	}
}
func ==(lhs: RoomType, rhs: RoomType) -> Bool {
	return lhs.id == rhs.id
}
