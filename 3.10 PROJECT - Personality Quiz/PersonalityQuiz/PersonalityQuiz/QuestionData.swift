//
//  QuestionData.swift
//  PersonalityQuiz
//
//  Created by Roman Martinez on 21/09/2017.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

struct Question {
	let type: QuestionType
	let text: String
	let answers: [Answer]
}
enum QuestionType {
	case single, multiple, range
}
struct Answer {
	let type: AnimalType
	let text: String
}
enum AnimalType: Character {
	case dog = "🐶"
	case cat = "🐱"
	case rabbit = "🐰"
	case turtle = "🐢"
	
	var definition: String {
		switch self {
			case .dog:
				return "You are incredibly outgoing. You surround yourself with the people you love and enjoy activities with your friends."
			case .cat:
				return "Mischievous, yet mild-tempered, you enjoy doing things on your own terms."
			case .rabbit:
				return "You love everything that's soft. You are healthy and full of energy."
			case .turtle:
				return "You are wise beyond your years, and you focus on the details. Slow and steady wins the race."
		}
	}
}
