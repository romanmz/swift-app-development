//
//  Athlete.swift
//  FavoriteAthlete
//
//  Created by Roman Martinez on 22/09/2017.
//
//

struct Athlete {
	let name: String
	let age: Int
	let league: String
	let team: String
	var description: String {
		return "\(name) is \(age) years old and plays for the \(team) in the \(league)"
	}
}
