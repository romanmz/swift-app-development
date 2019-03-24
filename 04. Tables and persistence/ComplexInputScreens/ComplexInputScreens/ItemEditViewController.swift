//
//  ItemEditViewController.swift
//  ComplexInputScreens
//
//  Created by Román Martínez on 3/11/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit

class ItemEditViewController: UITableViewController, UITextViewDelegate {
	
	
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
	@IBOutlet weak var stepperLabel: UILabel!
	@IBOutlet weak var stepperField: UIStepper!
	@IBOutlet weak var switchField: UISwitch!
	@IBOutlet weak var notesField: UITextView!
	@IBOutlet weak var saveButton: UIBarButtonItem!
	
	
	// Update UI
	// ------------------------------
	override func viewDidLoad() {
		super.viewDidLoad()
		updateUI()
		setupTextView()
	}
	func updateUI() {
		nameTextField.text = item.title
		datePickerField.date = item.date
		dateLabel.text = item.readableDate
		priorityLabel.text = item.priority.description
		stepperLabel.text = "\(item.amount)"
		stepperField.value = Double(item.amount)
		switchField.isOn = item.toggle
		notesField.text = item.notes
		toggleSaveButton()
	}
	func toggleSaveButton() {
		saveButton.isEnabled = !item.title.isEmpty && item.amount > 0
	}
	
	
	// Handle segues
	// ------------------------------
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		switch segue.identifier {
			case "showPriorityOptions": populatePriorityOptions(on: segue.destination)
			default: break
		}
	}
	@IBAction func unwindToItemEdit(segue: UIStoryboardSegue) {
		switch segue.identifier {
			case "selectedPriority": receivePriorityOption(from: segue.source)
			default: break
		}
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
		return super.tableView(tableView, heightForRowAt: indexPath)
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		if indexPath.section == 0 && indexPath.row == 1 {
			isEditingDate = !isEditingDate
		}
	}
	
	
	// Options selector
	// ------------------------------
	func populatePriorityOptions(on view: UIViewController) {
		guard let selectView = view as? OptionSelectViewController else { return }
		selectView.options = ListItemPriority.allCases
		selectView.selectedOption = item.priority
		selectView.navigationItem.title = "Item Priority"
	}
	func receivePriorityOption(from view: UIViewController) {
		guard let selectView = view as? OptionSelectViewController,
			let selectedPriority = selectView.selectedOption as? ListItemPriority else { return }
		item.priority = selectedPriority
	}
	
	
	// Stepper field
	// ------------------------------
	@IBAction func stepperFieldChanged(_ sender: UIStepper) {
		item.amount = Int(sender.value)
	}
	
	
	// Switch field
	// ------------------------------
	@IBAction func switchFieldChanged(_ sender: UISwitch) {
		item.toggle = sender.isOn
	}
	
	
	// Text field
	// ------------------------------
	// For multi-line text boxes you can use the UITextView element
	// however since it doesn't inherit from UIControl you'll need to handle it a bit differently
	// to detect changes on the text you need to attach a delegate object conforming to the UITextViewDelegate protocol
	func setupTextView() {
		notesField.delegate = self
	}
	func textViewDidChange(_ textView: UITextView) {
		item.notes = textView.text
	}
	
	
}
