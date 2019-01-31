//
//  ResultsViewController.swift
//  PersonalityQuiz
//
//  Created by Roman Martinez on 21/09/2017.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
	
	
	// PROPERTIES
	// ------------------------------
	var responses: [Answer]!
	@IBOutlet weak var resultTitle: UILabel!
	@IBOutlet weak var resultDescription: UILabel!
	
	
	// METHODS
	// ------------------------------
	override func viewDidLoad() {
        super.viewDidLoad()
		navigationItem.hidesBackButton = true
		calculatePesonalityResult()
    }
	
	func calculatePesonalityResult() {
		var frequencyOfAnswers: [AnimalType: Int] = [:]
		let responseTypes = responses.map { $0.type }
		for response in responseTypes {
			frequencyOfAnswers[response] = (frequencyOfAnswers[response] ?? 0) + 1
		}
		
		let mostCommonAnswer = frequencyOfAnswers.sorted { $0.value > $1.value }.first!.key
		resultTitle.text = "You are a \(mostCommonAnswer.rawValue)"
		resultDescription.text = mostCommonAnswer.definition
		
	}
	
	
}
