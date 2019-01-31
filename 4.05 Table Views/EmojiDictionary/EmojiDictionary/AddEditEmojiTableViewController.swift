//
//  AddEditEmojiTableViewController.swift
//  EmojiDictionary
//
//  Created by Roman Martinez on 24/09/2017.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import UIKit

class AddEditEmojiTableViewController: UITableViewController {
	
	
	var emoji: Emoji?
	@IBOutlet weak var symbolTextField: UITextField!
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var descriptionTextField: UITextField!
	@IBOutlet weak var usageTextField: UITextField!
	@IBOutlet weak var saveButton: UIBarButtonItem!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		if let emoji = emoji {
			symbolTextField.text = emoji.symbol
			nameTextField.text = emoji.name
			descriptionTextField.text = emoji.description
			usageTextField.text = emoji.usage
		}
		toggleSaveButton()
	}
	func toggleSaveButton() {
		let symbolText = symbolTextField.text ?? ""
		let nameText = nameTextField.text ?? ""
		let descriptionText = descriptionTextField.text ?? ""
		let usageText = usageTextField.text ?? ""
		saveButton.isEnabled = !symbolText.isEmpty && !nameText.isEmpty && !descriptionText.isEmpty && !usageText.isEmpty
	}
	
	
	@IBAction func editedTextField(_ sender: UITextField) {
		toggleSaveButton()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)
		
		if segue.identifier == "SaveUnwind" {
			let symbolText = symbolTextField.text ?? ""
			let nameText = nameTextField.text ?? ""
			let descriptionText = descriptionTextField.text ?? ""
			let usageText = usageTextField.text ?? ""
			emoji = Emoji(symbol: symbolText, name: nameText, description: descriptionText, usage: usageText)
		}
	}
	
}
