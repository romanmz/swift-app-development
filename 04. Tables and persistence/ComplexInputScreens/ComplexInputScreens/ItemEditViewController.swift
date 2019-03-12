//
//  ItemEditViewController.swift
//  ComplexInputScreens
//
//  Created by Román Martínez on 3/11/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit

class ItemEditViewController: UITableViewController {
	
	
	// Data
	// ------------------------------
	var item: ListItem! {
		didSet {
			if isViewLoaded {
				updateUI()
			}
		}
	}
	
	
	// Interface builder outlets
	// ------------------------------
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var datePickerField: UIDatePicker!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var priorityLabel: UILabel!
	@IBOutlet weak var saveButton: UIBarButtonItem!
	
	
	// Update UI
	// ------------------------------
	override func viewDidLoad() {
		super.viewDidLoad()
		updateUI()
	}
	func updateUI() {
		nameTextField.text = item.title
		datePickerField.date = item.date
		dateLabel.text = item.readableDate
		priorityLabel.text = item.priority.description
		toggleSaveButton()
	}
	func toggleSaveButton() {
		saveButton.isEnabled = !item.title.isEmpty
	}
	
	
	// Simple text field
	// ------------------------------
	@IBAction func nameFieldChanged(_ sender: UITextField) {
		item.title = sender.text ?? ""
	}
	
	
	// Date picker
	// ------------------------------
	@IBAction func datePickerChanged(_ sender: UIDatePicker) {
		item.date = sender.date
	}
	
	// Toggle table row
	var isEditingDate = false {
		didSet {
			tableView.beginUpdates()
			tableView.endUpdates()
		}
	}
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.section == 0 && indexPath.row == 2 {
			return isEditingDate ? datePickerField.intrinsicContentSize.height : 0.0
		}
		return 44.0
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		if indexPath.section == 0 && indexPath.row == 1 {
			isEditingDate = !isEditingDate
		}
	}
	
	
	// Options selector
	// ------------------------------
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard segue.identifier == "showPriorityOptions",
			let selectView = segue.destination as? OptionSelectViewController else { return }
		selectView.options = ListItemPriority.all
		selectView.selectedOption = item.priority
		selectView.navigationItem.title = "Item Priority"
	}
	@IBAction func unwindToItemEdit(segue: UIStoryboardSegue) {
		guard segue.identifier == "selectedPriority",
			let selectView = segue.source as? OptionSelectViewController,
			let selectedPriority = selectView.selectedOption as? ListItemPriority else { return }
		item.priority = selectedPriority
	}
	
	
}
