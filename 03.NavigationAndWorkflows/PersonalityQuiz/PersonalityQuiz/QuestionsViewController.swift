//
//  QuestionsViewController.swift
//  PersonalityQuiz
//
//  Created by Román Martínez on 3/7/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit

class QuestionsViewController: UIViewController, QuizDelegate {
	
	
	// Set up questions
	// ------------------------------
	var quiz: Quiz!
	override func viewDidLoad() {
		super.viewDidLoad()
		quiz = Quiz([
			Question(
				type: .single,
				text: "Which food do you like the most?",
				answers: [
					Answer(
						type: .dog,
						text: "Steak"
					),
					Answer(
						type: .cat,
						text: "Fish"
					),
					Answer(
						type: .rabbit,
						text: "Carrots"
					),
					Answer(
						type: .turtle,
						text: "Corn"
					),
				]
			),
			Question(
				type: .multiple,
				text: "Which activities do you enjoy?",
				answers: [
					Answer(
						type: .turtle,
						text: "Swimming"
					),
					Answer(
						type: .cat,
						text: "Sleeping"
					),
					Answer(
						type: .rabbit,
						text: "Cuddling"
					),
					Answer(
						type: .dog,
						text: "Eating"
					),
				]
			),
			Question(
				type: .range,
				text: "How much do you enjoy car rides?",
				answers: [
					Answer(
						type: .cat,
						text: "I dislike them"
					),
					Answer(
						type: .rabbit,
						text: "I get a little nervous"
					),
					Answer(
						type: .turtle,
						text: "I barely notice them"
					),
					Answer(
						type: .dog,
						text: "I love them"
					),
				]
			),
		])
		quiz.delegate = self
		quiz.nextQuestion()
	}
	
	
	// Interface Builder Outlets
	// ------------------------------
	
	// Main elements
	@IBOutlet weak var questionLabel: UILabel!
	@IBOutlet weak var progressBar: UIProgressView!
	
	// Single answer
	@IBOutlet weak var singleAnswerBox: UIStackView!
	@IBOutlet var singleAnswerButtons: [UIButton]!
	
	// Multiple answers
	@IBOutlet weak var multipleAnswersBox: UIStackView!
	@IBOutlet var multipleAnswerLabels: [UILabel]!
	@IBOutlet var multipleAnswerSwitches: [UISwitch]!
	
	// Range answer
	@IBOutlet weak var rangeAnswerBox: UIStackView!
	@IBOutlet weak var rangeInput: UISlider!
	@IBOutlet weak var rangeLabel1: UILabel!
	@IBOutlet weak var rangeLabel2: UILabel!
	
	
	// Update UI
	// ------------------------------
	func updateUI() {
		let question = quiz.currentQuestion
		
		// Hide all containers
		singleAnswerBox.isHidden = true
		multipleAnswersBox.isHidden = true
		rangeAnswerBox.isHidden = true
		
		// Update question
		questionLabel.text = question.text
		
		// Update answers
		switch question.type {
		case .single:
			showSingleAnswers(question.answers)
		case .multiple:
			showMultipleAnswers(question.answers)
		case .range:
			showRangeAnswers(question.answers)
		}
		
		// Update progress bar
		progressBar.setProgress(quiz.currentProgress, animated: true)
	}
	
	
	// Update answers
	// ------------------------------
	func showSingleAnswers(_ answers: [Answer]) {
		singleAnswerBox.isHidden = false
		for (index, answer) in answers.enumerated() {
			singleAnswerButtons[index].setTitle(answer.text, for: .normal)
		}
	}
	func showMultipleAnswers(_ answers: [Answer]) {
		multipleAnswersBox.isHidden = false
		for (index, answer) in answers.enumerated() {
			multipleAnswerLabels[index].text = answer.text
			multipleAnswerSwitches[index].isOn = false
		}
	}
	func showRangeAnswers(_ answers: [Answer]) {
		rangeAnswerBox.isHidden = false
		rangeInput.value = 0.5
		rangeLabel1.text = answers.first?.text
		rangeLabel2.text = answers.last?.text
	}
	
	
	// Delegate methods
	// ------------------------------
	func presentQuestion(_ question: Question) {
		updateUI()
	}
	func finishedQuiz(_ result: AnimalType) {
	}
	
	
	// User interaction
	// ------------------------------
	@IBAction func singleAnswerSelected(_ sender: Any) {
		guard let button = sender as? UIButton,
			let index = singleAnswerButtons.firstIndex(of: button) else { return }
		let answer = quiz.currentQuestion.answers[index]
		quiz.addAnswer(answer)
		quiz.nextQuestion()
	}
	@IBAction func multipleAnswersSubmitted() {
		var atLeastOne = false
		for (index, answer) in quiz.currentQuestion.answers.enumerated() {
			if multipleAnswerSwitches[index].isOn {
				quiz.addAnswer(answer)
				atLeastOne = true
			}
		}
		if atLeastOne {
			quiz.nextQuestion()
		}
	}
	@IBAction func rangeAnswerSubmitted() {
		let answers = quiz.currentQuestion.answers
		let index = Int( (rangeInput.value * 0.999999) * Float(answers.count) )
		quiz.addAnswer(answers[index])
		quiz.nextQuestion()
	}
}
