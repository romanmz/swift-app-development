//
//  ViewController.swift
//  Apple Pie
//
//  Created by Roman Martinez on 19/09/2017.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	
	// Properties
	// ------------------------------
	var listOfWords = ["buccaneer", "swift", "glorious", "incandescent", "bug", "program"]
	let errorsAllowed = 7
	var totalWins = 0 {
		didSet {
			newRound()
		}
	}
	var totalLosses = 0 {
		didSet {
			newRound()
		}
	}
	var currentGame: Game!
	
	// Interface Builder
	@IBOutlet weak var treeImageView: UIImageView!
	@IBOutlet weak var correctWordLabel: UILabel!
	@IBOutlet weak var scoreLabel: UILabel!
	@IBOutlet var letterButtons: [UIButton]!
	
	
	// View Events
	// ------------------------------
	override func viewDidLoad() {
		super.viewDidLoad()
		newRound()
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	
	// Game Functions
	// ------------------------------
	func newRound() {
		if !listOfWords.isEmpty {
			let newWord = listOfWords.removeFirst()
			currentGame = Game(word: newWord, errorsAllowed: errorsAllowed)
			enableLetterButtons(true)
			updateUI()
		} else {
			enableLetterButtons(false)
			updateUI()
			correctWordLabel.text = "Game ended"
		}
	}
	func enableLetterButtons(_ enable: Bool) {
		for button in letterButtons {
			button.isEnabled = enable
		}
	}
	func updateUI() {
		scoreLabel.text = "Wins: \(totalWins), Losses: \(totalLosses)"
		treeImageView.image = UIImage(named: "Tree \(currentGame.errorsAllowed)")
		correctWordLabel.text = currentGame.formattedWord.characters.map { String($0) }.joined(separator: " ")
	}
	
	
	@IBAction func buttonPressed(_ sender: UIButton) {
		sender.isEnabled = false
		guard let letterString = sender.title(for: .normal) else {
			return
		}
		if !letterString.isEmpty {
			let letter: Character = Character(letterString.lowercased())
			currentGame.playerGuessed(letter: letter)
			updateGameState()
		}
	}
	
	func updateGameState() {
		if currentGame.formattedWord == currentGame.word {
			totalWins += 1
		} else if currentGame.errorsAllowed < 1 {
			totalLosses += 1
		} else {
			updateUI()
		}
	}
	
	
}
