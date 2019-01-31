//
//  File.swift
//  Apple Pie
//
//  Created by Roman Martinez on 19/09/2017.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import Foundation

struct Game {
	var word: String
	var errorsAllowed: Int
	var guessedLetters = [Character]()
	
	init(word: String, errorsAllowed: Int) {
		self.word = word
		self.errorsAllowed = errorsAllowed
	}
	mutating func playerGuessed(letter: Character) {
		if !guessedLetters.contains(letter) {
			guessedLetters.append(letter)
			if !word.characters.contains(letter) {
				errorsAllowed -= 1
			}
		}
	}
	var formattedWord: String {
		var result = ""
		for letter in word.characters {
			if guessedLetters.contains(letter) {
				result += "\(letter)"
			} else {
				result += "_"
			}
		}
		return result
	}
}
