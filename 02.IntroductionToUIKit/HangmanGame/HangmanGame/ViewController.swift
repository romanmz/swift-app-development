//
//  ViewController.swift
//  HangmanGame
//
//  Created by Román Martínez on 3/5/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit

class ViewController: UIViewController, HangmanGameDelegate {
	
	
	// Interface elements
	// ------------------------------
	@IBOutlet weak var scoreLabel: UILabel!
	@IBOutlet weak var image: UIImageView!
	@IBOutlet var letterButtons: [UIButton]!
	@IBOutlet weak var wordLabel: UILabel!
	
	
	// Game settings
	// ------------------------------
	
	// Games data
	var game: HangmanGame!
	let words = ["buccaneer", "swift", "glorious", "incandescent", "bug", "program"]
	let maxErrorsAllowed = 7
	
	// Set up
	override func viewDidLoad() {
		super.viewDidLoad()
		game = HangmanGame(words: words, maxErrors: maxErrorsAllowed)
		game.delegate = self
		game.nextRound()
		for button in letterButtons {
			button.addTarget(self, action: #selector(letterButtonPressed(_:)), for: .touchUpInside)
		}
	}
	
	// User actions
	@objc func letterButtonPressed(_ sender: UIButton) {
		sender.isEnabled = false
		guard let letter = sender.title(for: .normal)?.first else { return }
		game.playLetter(letter)
	}
	
	
	// Delegate methods
	// ------------------------------
	func startedTurn(_ game: HangmanGame) {
		updateUI()
	}
	func startedRound(_ game: HangmanGame) {
		updateUI()
	}
	func gameWon(_ game: HangmanGame) {
		updateUI()
	}
	func gameLost(_ game: HangmanGame) {
		updateUI()
	}
	
	
	// Update UI
	// ------------------------------
	func updateUI() {
		// Score label and buttons
		switch game.status {
		case .won, .lost:
			scoreLabel.text = "\(game.roundsWon) rounds won / \(game.roundsLost) rounds lost"
			toggleLetterButtons(false)
		default:
			scoreLabel.text = "Round #\(game.currentRoundNumber) of \(game.totalRounds)"
			toggleLetterButtons(true)
		}
		// Image
		image.image = UIImage(named: "Tree \(game.currentRound?.turnsLeft ?? 0)")
		// Word label
		switch game.status {
		case .won:
			wordLabel.text = "You won!"
		case .lost:
			wordLabel.text = "Game over!"
		default:
			wordLabel.text = game.currentRound?.guessedWordFormatted ?? ""
		}
	}
	func toggleLetterButtons(_ enabled: Bool) {
		for button in letterButtons {
			button.isEnabled = enabled
		}
	}
}
