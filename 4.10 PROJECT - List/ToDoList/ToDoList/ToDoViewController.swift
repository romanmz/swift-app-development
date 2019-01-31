//
//  ToDoViewController.swift
//  ToDoList
//
//  Created by Roman Martinez on 27/9/17.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController {
	
	// Properties
	var isDatePickerHidden = true
	var todo: ToDo?
	
	// Outlets
	@IBOutlet weak var saveButton: UIBarButtonItem!
	@IBOutlet weak var isCompleteButton: UIButton!
	@IBOutlet weak var titleTextField: UITextField!
	@IBOutlet weak var dueDateLabel: UILabel!
	@IBOutlet weak var dueDatePicker: UIDatePicker!
	@IBOutlet weak var notesTextView: UITextView!
	
	
	// Methods
	override func viewDidLoad() {
		super.viewDidLoad()
		if let todo = self.todo {
			navigationItem.title = "To-Do"
			titleTextField.text = todo.title
			isCompleteButton.isSelected = todo.isComplete
			dueDatePicker.date = todo.dueDate
			notesTextView.text = todo.notes
		} else {
			dueDatePicker.date = Date().addingTimeInterval(24*60*60)
		}
		updateDueDateLabel()
		updateSaveButton()
	}
	func updateDueDateLabel() {
		dueDateLabel.text = ToDo.dueDateFormatter.string(from: dueDatePicker.date)
	}
	func updateSaveButton() {
		let title = titleTextField.text ?? ""
		saveButton.isEnabled = !title.isEmpty
	}
	
	// Complete toggle
	@IBAction func isCompleteButtonTapped(_ sender: UIButton) {
		isCompleteButton.isSelected = !isCompleteButton.isSelected
	}
	
	// Title Field
	@IBAction func titleTextChanged(_ sender: UITextField) {
		updateSaveButton()
	}
	@IBAction func titleTextReturn(_ sender: UITextField) {
		titleTextField.resignFirstResponder()
	}
	
	// Date Field
	@IBAction func dueDateChanged(_ sender: UIDatePicker) {
		updateDueDateLabel()
	}
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		let normalCellHeight = CGFloat(44)
		let largeCellHeight = CGFloat(200)
		switch indexPath {
		case [1,0]:
			return isDatePickerHidden ? normalCellHeight : largeCellHeight
		case [2,0]:
			return largeCellHeight
		default:
			return normalCellHeight
		}
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		if indexPath == [1,0] {
			isDatePickerHidden = !isDatePickerHidden
			dueDateLabel.textColor = isDatePickerHidden ? .black : tableView.tintColor
			tableView.beginUpdates()
			tableView.endUpdates()
		}
	}
	
	// Cancel / Save
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)
		if segue.identifier == "SaveUnwind" {
			let title = titleTextField.text ?? "[untitled]"
			let isComplete = isCompleteButton.isSelected
			let dueDate = dueDatePicker.date
			let notes = notesTextView.text
			self.todo = ToDo(title: title, isComplete: isComplete, dueDate: dueDate, notes: notes)
		}
	}
	
}
