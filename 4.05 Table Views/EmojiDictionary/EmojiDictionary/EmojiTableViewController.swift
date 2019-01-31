//
//  EmojiTableViewController.swift
//  EmojiDictionary
//
//  Created by Roman Martinez on 22/09/2017.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import UIKit

class EmojiTableViewController: UITableViewController {
	
	
	// PROPERTIES
	// ------------------------------
	var emojis: [EmojiSection] = [] {
		didSet {
			Emoji.saveToFile(emojis: emojis)
		}
	}
	
	
	// METHODS
	// ------------------------------
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Load saved data
		if let savedEmojis = Emoji.loadFromFile() {
			emojis = savedEmojis
		} else {
			emojis = Emoji.sampleEmojis
		}
		
		// Add 'Edit' button
		navigationItem.leftBarButtonItem = editButtonItem
		
		// Auto-height for rows
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 54.0
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "EditEmoji" {
			guard let selectedCell = tableView.indexPathForSelectedRow else { return }
			guard let navController = segue.destination as? UINavigationController else { return }
			guard let editScreenController = navController.topViewController as? AddEditEmojiTableViewController else { return }
			let selectedEmoji = emojis[ selectedCell.section ].emojis[ selectedCell.row ]
			editScreenController.emoji = selectedEmoji
		}
	}
	@IBAction func unwindToEmojiTableViewWithSegue(segue: UIStoryboardSegue) {
		if segue.identifier == "SaveUnwind" {
			guard let addEditViewController = segue.source as? AddEditEmojiTableViewController else { return }
			guard let emoji = addEditViewController.emoji else { return }
			if let selectedCell = tableView.indexPathForSelectedRow {
				emojis[ selectedCell.section ].emojis[ selectedCell.row ] = emoji
				tableView.reloadRows(at: [selectedCell], with: .none)
			} else {
				let section = emojis.count - 1
				let row = emojis[section].emojis.count
				let newIndex = IndexPath(row: row, section: section)
				emojis[section].emojis.append(emoji)
				tableView.insertRows(at: [newIndex], with: .automatic)
			}
		}
	}
	
	
	// UI TABLE VIEW DATA SOURCE
	// ------------------------------
	override func numberOfSections(in tableView: UITableView) -> Int {
		return emojis.count
	}
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String {
		return emojis[section].name
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return emojis[section].emojis.count
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "EmojiCell", for: indexPath) as! EmojiTableViewCell
		let emoji = emojis[ indexPath.section ].emojis[ indexPath.row ]
		cell.update(with: emoji)
		return cell
	}
	override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
		let movedEmoji = emojis[ fromIndexPath.section ].emojis.remove(at: fromIndexPath.row)
		emojis[ to.section ].emojis.insert(movedEmoji, at: to.row)
		tableView.reloadData()
	}
	
	
	// UI TABLE VIEW DELEGATE
	// ------------------------------
	override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
		return .delete
	}
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			emojis[ indexPath.section ].emojis.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .automatic)
		}
	}
	override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
		if sourceIndexPath.section != proposedDestinationIndexPath.section {
			return sourceIndexPath
		}
		return proposedDestinationIndexPath
	}
	
	
}
