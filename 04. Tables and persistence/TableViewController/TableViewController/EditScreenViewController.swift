//
//  EditScreenViewController.swift
//  TableViewController
//
//  Created by Román Martínez on 3/10/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit

class EditScreenViewController: UITableViewController {
	
	
	// Properties
	// ------------------------------
	var row: TableRow?
	@IBOutlet weak var symbolTextField: UITextField!
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var descriptionTextField: UITextField!
	@IBOutlet weak var saveButton: UIBarButtonItem!
	
	
	// Populate fields
	// ------------------------------
	override func viewDidLoad() {
		super.viewDidLoad()
		if let row = row {
			symbolTextField.text = row.symbol
			nameTextField.text = row.name
			descriptionTextField.text = row.description
		}
		toggleSaveButton()
	}
	
	
	// Enable/disable save button
	// ------------------------------
	func toggleSaveButton() {
		let symbolText = symbolTextField.text ?? ""
		let nameText = nameTextField.text ?? ""
		let descriptionText = descriptionTextField.text ?? ""
		saveButton.isEnabled = !symbolText.isEmpty && !nameText.isEmpty && !descriptionText.isEmpty
	}
	@IBAction func editedTextField(_ sender: UITextField) {
		toggleSaveButton()
	}
	
	
	// Prepare data for saving
	// ------------------------------
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)
		guard segue.identifier == "saveEditing" else { return }
		let symbolText = symbolTextField.text ?? ""
		let nameText = nameTextField.text ?? ""
		let descriptionText = descriptionTextField.text ?? ""
		row = TableRow(symbol: symbolText, name: nameText, description: descriptionText)
	}
}
