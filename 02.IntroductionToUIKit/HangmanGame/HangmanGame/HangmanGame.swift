//
//  HangmanGame.swift
//  HangmanGame
//
//  Created by Román Martínez on 3/5/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import Foundation



// ==================================================
// Hangman Game Delegate
// ==================================================
protocol HangmanGameDelegate {
	func startedTurn(_:HangmanGame)
	func startedRound(_:HangmanGame)
	func gameWon(_:HangmanGame)
	func gameLost(_:HangmanGame)
}



// ==================================================
// Hangman Game
// ==================================================
class HangmanGame {
	
	
	// Properties
	// ------------------------------
	
	// Game data
	let words: [String]
	let maxErrorsPerRound: Int
	var delegate: HangmanGameDelegate?
	
	// Rounds info
	var currentRound: HangmanRound?
	var currentRoundNumber = 0
	var roundsLost = 0
	var roundsWon: Int {
		return currentRoundNumber - 1 - roundsLost
	}
	var totalRounds: Int {
		return words.count
	}
	
	// Game status
	enum HangmanGameStatus {
		case playing, won, lost
	}
	var status: HangmanGameStatus {
		if roundsLost > 0 {
			return .lost
		} else if currentRoundNumber > totalRounds {
			return .won
		}
		return .playing
	}
	
	
	// Constructor
	// ------------------------------
	init(words: [String], maxErrors: Int) {
		self.words = words
		self.maxErrorsPerRound = maxErrors
	}
	
	
	// Move through rounds
	// ------------------------------
	func nextRound() {
		currentRoundNumber += 1
		switch status {
		case .lost:
			gameLost()
		case .won:
			gameWon()
		default:
			newRound(currentRoundNumber)
		}
	}
	func newTurn() {
		delegate?.startedTurn(self)
	}
	func newRound(_ number: Int) {
		let word = words[number-1]
		currentRound = HangmanRound(word: word, maxErrors: maxErrorsPerRound)
		delegate?.startedRound(self)
	}
	func gameLost() {
		currentRound = nil
		delegate?.gameLost(self)
	}
	func gameWon() {
		currentRound = nil
		delegate?.gameWon(self)
	}
	
	
	// User actions
	// ------------------------------
	func playLetter(_ letter: Character) {
		guard let round = currentRound else { return }
		round.playLetter(letter)
		
		// Check status and move to next stage if necessary
		switch round.status {
		case .lost:
			roundsLost += 1
			nextRound()
		case .won:
			nextRound()
		default:
			newTurn()
		}
	}
}



// ==================================================
// Hangman Round
// ==================================================
class HangmanRound {
	
	
	// Properties
	// ------------------------------
	
	// Round data
	let word: String
	let maxErrors: Int
	
	// Turns info
	var turnsLeft: Int
	var guessedLetters: Set<Character> = []
	var guessedWord: String {
		var word = ""
		for letter in self.word {
			word += guessedLetters.contains(letter) ? "\(letter)" : "_"
		}
		return word
	}
	var guessedWordFormatted: String {
		return guessedWord.map { String($0) }.joined(separator: " ")
	}
	
	// Round status
	enum HangmanRoundStatus {
		case playing, won, lost
	}
	var status: HangmanRoundStatus {
		if word == guessedWord {
			return .won
		} else if turnsLeft <= 0 {
			return .lost
		} else {
			return .playing
		}
	}
	
	
	// Constructor
	// ------------------------------
	init(word: String, maxErrors: Int) {
		self.word = word.lowercased()
		self.maxErrors = maxErrors
		self.turnsLeft = maxErrors
	}
	
	
	// User actions
	// ------------------------------
	func playLetter(_ letter: Character) {
		let lowercaseLetter = Character("\(letter)".lowercased())
		// Exit if chosen letter has already been used
		if guessedLetters.contains(lowercaseLetter) { return }
		// Update data
		guessedLetters.insert(lowercaseLetter)
		if !word.contains(lowercaseLetter) {
			turnsLeft -= 1
		}
	}
}
