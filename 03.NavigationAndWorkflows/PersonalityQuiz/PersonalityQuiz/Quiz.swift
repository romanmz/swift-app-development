//
//  Quiz.swift
//  PersonalityQuiz
//
//  Created by Román Martínez on 3/7/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import Foundation


// ==============================
// Quiz Delegate
// ==============================
protocol QuizDelegate {
	func presentQuestion(_ question: Question)
	func finishedQuiz(_ result: AnimalType)
}


// ==============================
// Quiz
// ==============================
class Quiz {
	
	
	// Properties
	// ------------------------------
	
	// Quiz data
	let questions: [Question]
	var delegate: QuizDelegate?
	var answersChosen: [Answer] = []
	
	// Quiz status
	var currentQuestionNumber = 0
	var currentQuestion: Question {
		return questions[currentQuestionNumber - 1]
	}
	var currentProgress: Float {
		return Float(currentQuestionNumber - 1) / Float(totalQuestions)
	}
	var totalQuestions: Int {
		return questions.count
	}
	
	
	// Constructor
	// ------------------------------
	init(_ questions: [Question]) {
		self.questions = questions
	}
	func calculateResult() -> AnimalType {
		var frequencyOfTypes: [AnimalType: Int] = [:]
		let selectedTypes = answersChosen.map { $0.type }
		for type in selectedTypes {
			frequencyOfTypes[type, default: 0] += 1
		}
		let mostCommonType = frequencyOfTypes.sorted { $0.value > $1.value }.first!.key
		return mostCommonType
	}
	
	
	// Walk through the questions
	// ------------------------------
	func nextQuestion() {
		currentQuestionNumber += 1
		if currentQuestionNumber <= totalQuestions {
			presentQuestion(number: currentQuestionNumber)
		} else {
			finishedQuiz()
		}
	}
	func presentQuestion(number: Int) {
		delegate?.presentQuestion(currentQuestion)
	}
	func finishedQuiz() {
		let result = calculateResult()
		delegate?.finishedQuiz(result)
	}
	
	
	// Handle answers
	// ------------------------------
	func addAnswer(_ answer: Answer) {
		answersChosen.append(answer)
	}
}
