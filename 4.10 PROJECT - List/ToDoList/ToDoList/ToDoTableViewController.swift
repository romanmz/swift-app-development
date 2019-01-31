//
//  ToDoTableViewController.swift
//  ToDoList
//
//  Created by Roman Martinez on 27/9/17.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import UIKit

class ToDoTableViewController: UITableViewController, ToDoCellDelegate {
	
	
	// Properties
	// ------------------------------
	var todos: [ToDo] = []
	
	
	// Methods
	// ------------------------------
    override func viewDidLoad() {
		
		navigationItem.leftBarButtonItem = editButtonItem
        super.viewDidLoad()
		if let savedToDos = ToDo.loadToDos() {
			todos = savedToDos
		} else {
			todos = ToDo.loadSampleToDos()
		}
    }
	
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell") as? ToDoCell else { fatalError("Could not dequeue a cell") }
		let todo = todos[indexPath.row]
		cell.delegate = self
		cell.isCompleteButton.isSelected = todo.isComplete
		cell.titleLabel.text = todo.title
		return cell
    }
	
	// Update checkmarks
	func checkmarkTapped(sender: ToDoCell) {
		guard let index = tableView.indexPath(for: sender) else { return }
		var todo = todos[index.row]
		todo.isComplete = !todo.isComplete
		todos[index.row] = todo
		tableView.reloadRows(at: [index], with: .automatic)
		
		// `save
		ToDo.saveToDos(todos)
	}
	
	// Editing cells
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			todos.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .automatic)
			
			// `save
			ToDo.saveToDos(todos)
		}
	}
	
    // MARK: - Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)
		if segue.identifier == "ShowDetails" {
			guard let navController = segue.destination as? UINavigationController else { return }
			guard let viewController = navController.topViewController as? ToDoViewController else { return }
			guard let selectedIndex = tableView.indexPathForSelectedRow else { return }
			let selectedTodo = todos[selectedIndex.row]
			viewController.todo = selectedTodo
		}
	}
	@IBAction func unwindToToDoList(segue: UIStoryboardSegue) {
		if segue.identifier == "SaveUnwind" {
			guard let viewController = segue.source as? ToDoViewController else { return }
			guard let todo = viewController.todo else { return }
			if let selectedIndex = tableView.indexPathForSelectedRow {
				todos[selectedIndex.row] = todo
				tableView.reloadRows(at: [selectedIndex], with: .none)
			} else {
				let newIndex = IndexPath(row: todos.count, section: 0)
				todos.append(todo)
				tableView.insertRows(at: [newIndex], with: .automatic)
			}
			
			// `save
			ToDo.saveToDos(todos)
		}
	}
	
}
