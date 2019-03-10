//
//  PersistentData.swift
//  TableViewController
//
//  Created by Román Martínez on 3/9/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import Foundation


// Load/save to file
// ------------------------------

// Must conform to the "Codable" protocol
extension TableData {
	static var archiveURL: URL {
		let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		return documentsDirectory.appendingPathComponent("tableData").appendingPathExtension("plist")
	}
	static func saveToFile(data: TableData) {
		let encoder = PropertyListEncoder()
		let encodedEmojis = try? encoder.encode(data)
		try? encodedEmojis?.write(to: archiveURL, options: .noFileProtection)
	}
	static func loadFromFile() -> TableData? {
		let decoder = PropertyListDecoder()
		guard let encodedData = try? Data(contentsOf: archiveURL),
			let decodedData = try? decoder.decode(TableData.self, from: encodedData) else { return nil }
		return decodedData
	}
}


// Fallback to sample data
// ------------------------------

extension TableViewController {
	func loadInitialData() -> TableData {
		if let savedData = TableData.loadFromFile() {
			return savedData
		} else {
			return TableData.sampleData
		}
	}
}
