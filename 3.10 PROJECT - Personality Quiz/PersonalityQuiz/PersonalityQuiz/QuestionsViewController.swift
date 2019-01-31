//
//  QuestionsViewController.swift
//  PersonalityQuiz
//
//  Created by Roman Martinez on 21/09/2017.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import UIKit

class QuestionsViewController: UIViewController {
	
	
	// PROPERTIES
	// ------------------------------
	let questions: [Question] = [
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
	]
	var questionIndex = 0
	var answersChosen: [Answer] = []
	
	
	// Interface Builder
	@IBOutlet weak var questionLabel: UILabel!
	@IBOutlet weak var testProgress: UIProgressView!
	
	@IBOutlet weak var singleStackView: UIStackView!
	@IBOutlet weak var singleButton1: UIButton!
	@IBOutlet weak var singleButton2: UIButton!
	@IBOutlet weak var singleButton3: UIButton!
	@IBOutlet weak var singleButton4: UIButton!
	
	@IBOutlet weak var multipleStackView: UIStackView!
	@IBOutlet weak var multipleLabel1: UILabel!
	@IBOutlet weak var multipleLabel2: UILabel!
	@IBOutlet weak var multipleLabel3: UILabel!
	@IBOutlet weak var multipleLabel4: UILabel!
	@IBOutlet weak var multiSwitch1: UISwitch!
	@IBOutlet weak var multiSwitch2: UISwitch!
	@IBOutlet weak var multiSwitch3: UISwitch!
	@IBOutlet weak var multiSwitch4: UISwitch!
	
	@IBOutlet weak var rangeStackView: UIStackView!
	@IBOutlet weak var rangeLabel1: UILabel!
	@IBOutlet weak var rangeLabel2: UILabel!
	@IBOutlet weak var rangeSlider: UISlider!
	
	
	// METHODS
	// ------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
		updateUI()
    }
	func updateUI() {
		let currentQuestion = questions[questionIndex]
		let currentProgress = Float(questionIndex) / Float(questions.count)
		
		navigationItem.title = "Question #\(questionIndex + 1)"
		questionLabel.text = currentQuestion.text
		testProgress.setProgress(currentProgress, animated: true)
		
		// Reset
		singleStackView.isHidden = true
		multipleStackView.isHidden = true
		rangeStackView.isHidden = true
		multiSwitch1.isOn = false
		multiSwitch2.isOn = false
		multiSwitch3.isOn = false
		multiSwitch4.isOn = false
		rangeSlider.value = 0.5
		
		// Trigger extra initializers for each question type
		switch currentQuestion.type {
			case .single:
				updateSingleStack()
			case .multiple:
				updateMultipleStack()
			case .range:
				updateRangeStack()
		}
	}
	func updateSingleStack() {
		let answers = questions[questionIndex].answers
		singleStackView.isHidden = false
		singleButton1.setTitle(answers[0].text, for: .normal)
		singleButton2.setTitle(answers[1].text, for: .normal)
		singleButton3.setTitle(answers[2].text, for: .normal)
		singleButton4.setTitle(answers[3].text, for: .normal)
	}
	func updateMultipleStack() {
		let answers = questions[questionIndex].answers
		multipleStackView.isHidden = false
		multipleLabel1.text = answers[0].text
		multipleLabel2.text = answers[1].text
		multipleLabel3.text = answers[2].text
		multipleLabel4.text = answers[3].text
	}
	func updateRangeStack() {
		let answers = questions[questionIndex].answers
		rangeStackView.isHidden = false
		rangeLabel1.text = answers.first?.text
		rangeLabel2.text = answers.last?.text
	}
	func nextQuestion() {
		questionIndex += 1
		if questionIndex < questions.count {
			updateUI()
		} else {
			performSegue(withIdentifier: "ResultsSegue", sender: nil)
		}
	}
	
	
	@IBAction func singleAnswerButtonPressed(_ sender: UIButton) {
		let answers = questions[questionIndex].answers
		switch sender {
			case singleButton1:
				answersChosen.append(answers[0])
			case singleButton2:
				answersChosen.append(answers[1])
			case singleButton3:
				answersChosen.append(answers[2])
			case singleButton4:
				answersChosen.append(answers[3])
			default:
				break
		}
		nextQuestion()
	}
	@IBAction func multipleAnswerButtonPressed() {
		let answers = questions[questionIndex].answers
		if multiSwitch1.isOn {
			answersChosen.append(answers[0])
		}
		if multiSwitch2.isOn {
			answersChosen.append(answers[1])
		}
		if multiSwitch3.isOn {
			answersChosen.append(answers[2])
		}
		if multiSwitch4.isOn {
			answersChosen.append(answers[3])
		}
		nextQuestion()
	}
	@IBAction func rangedAnswerButtonPressed() {
		let answers = questions[questionIndex].answers
		let value = Int( (rangeSlider.value * 0.999999) * Float(answers.count) )
		answersChosen.append(answers[value])
		nextQuestion()
	}
	
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard segue.identifier == "ResultsSegue" else { return }
		guard let resultsViewController = segue.destination as? ResultsViewController else { return }
		resultsViewController.responses = answersChosen
	}
	
	
}
