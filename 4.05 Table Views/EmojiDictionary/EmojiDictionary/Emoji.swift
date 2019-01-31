//
//  Emoji.swift
//  EmojiDictionary
//
//  Created by Roman Martinez on 22/09/2017.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//
import UIKit

struct EmojiSection: Codable {
	let name: String
	var emojis: [Emoji]
}
struct Emoji: Codable {
	let symbol: String
	let name: String
	let description: String
	let usage: String
	
	static var archiveURL: URL {
		let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		let fileURL = documentsDirectory.appendingPathComponent("emojis").appendingPathExtension("plist")
		return fileURL
	}
	static func saveToFile(emojis: [EmojiSection]) {
		let encoder = PropertyListEncoder()
		let encodedEmojis = try? encoder.encode(emojis)
		try? encodedEmojis?.write(to: archiveURL, options: .noFileProtection)
	}
	static func loadFromFile() -> [EmojiSection]? {
		let decoder = PropertyListDecoder()
		guard let encodedEmojis = try? Data(contentsOf: archiveURL) else { return nil }
		guard let decodedEmojis = try? decoder.decode(Array<EmojiSection>.self, from: encodedEmojis) else { return nil }
		return decodedEmojis
	}
	static var sampleEmojis: [EmojiSection] {
		return [
			EmojiSection(
				name: "Smileys",
				emojis: [
					Emoji(symbol: "😀", name: "Grinning Face", description: "A typical smiley face.", usage: "happiness"),
					Emoji(symbol: "😕", name: "Confused Face", description: "A confused, puzzled face.", usage: "unsure what to think; displeasure"),
					Emoji(symbol: "😍", name: "Heart Eyes", description: "A smiley face with hearts for eyes.", usage: "love of something; attractive"),
					Emoji(symbol: "👮", name: "Police Officer", description: "A police officer wearing a blue cap with a gold badge.", usage: "person of authority"),
				]
			),
			EmojiSection(
				name: "Animals",
				emojis: [
					Emoji(symbol: "🐢", name: "Turtle", description: "A cute turtle.", usage: "Something slow"),
					Emoji(symbol: "🐘", name: "Elephant", description: "A gray elephant.", usage: "good memory"),
				]
			),
			EmojiSection(
				name: "Other",
				emojis: [
					Emoji(symbol: "🍝", name: "Spaghetti", description: "A plate of spaghetti.", usage: "spaghetti"),
					Emoji(symbol: "🎲", name: "Die", description: "A single die.", usage: "taking a risk, chance; game"),
					Emoji(symbol: "⛺️", name: "Tent", description: "A small tent.", usage: "camping"),
					Emoji(symbol: "📚", name: "Stack of Books", description: "Three colored books stacked on each other.", usage: "homework, studying"),
					Emoji(symbol: "💔", name: "Broken Heart", description: "A red, broken heart.", usage: "extreme sadness"),
					Emoji(symbol: "💤", name: "Snore", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam id eros maximus, iaculis risus a, viverra arcu. Ut ac molestie mauris, vel pretium tellus. Pellentesque quis elit sit amet eros tincidunt fringilla nec sed velit. Integer rhoncus libero non ex pretium, in auctor dui efficitur. Proin nisl erat, consequat sit amet sapien id, vestibulum finibus nulla. Fusce id volutpat arcu. Phasellus sagittis sed massa quis consectetur. Nullam finibus risus at velit interdum, vitae interdum est tempus. Ut vestibulum neque eget tempor elementum.", usage: "tired, sleepiness"),
					Emoji(symbol: "🏁", name: "Checkered Flag", description: "A black-and-white checkered flag.", usage: "completion"),
				]
			),
		]
	}
}
