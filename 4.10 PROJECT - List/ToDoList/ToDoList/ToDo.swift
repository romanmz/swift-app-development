//
//  ToDo.swift
//  ToDoList
//
//  Created by Roman Martinez on 27/9/17.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import Foundation

struct ToDo: Codable {
	var title: String
	var isComplete: Bool
	var dueDate: Date
	var notes: String?
	static let dueDateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .short
		formatter.timeStyle = .short
		return formatter
	}()
	static let archiveURL: URL = {
		let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		let archiveURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("plist")
		return archiveURL
	}()
	
	static func saveToDos(_ todos: [ToDo]) {
		let encoder = PropertyListEncoder()
		let encodedTodos = try? encoder.encode(todos)
		try? encodedTodos?.write(to: archiveURL, options: .noFileProtection)
	}
	static func loadToDos() -> [ToDo]? {
		guard let todosData = try? Data(contentsOf: archiveURL) else { return nil }
		let decoder = PropertyListDecoder()
		return try? decoder.decode([ToDo].self, from: todosData)
	}
	static func loadSampleToDos() -> [ToDo] {
		let todo1 = ToDo(title: "ToDo 1", isComplete: false, dueDate: Date(), notes: "notes 1")
		let todo2 = ToDo(title: "ToDo 2", isComplete: true, dueDate: Date(), notes: "notes 2")
		let todo3 = ToDo(title: "ToDo 3", isComplete: false, dueDate: Date(), notes: "notes 3")
		return [todo1, todo2, todo3]
	}
}
