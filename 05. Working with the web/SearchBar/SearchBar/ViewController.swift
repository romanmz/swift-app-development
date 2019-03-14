//
//  ViewController.swift
//  SearchBar
//
//  Created by Román Martínez on 3/14/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UISearchBarDelegate {
	
	
	// Initialize
	// ------------------------------
	override func viewDidLoad() {
		super.viewDidLoad()
		setupSearchBar()
	}
	
	
	// Current terms
	// ------------------------------
	var currentSegment: String {
		return segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex ) ?? ""
	}
	var currentKeyword: String {
		return searchBar.text ?? ""
	}
	func getKeywordCharacter(at index: Int) -> Character {
		let stringIndex = currentKeyword.index(currentKeyword.startIndex, offsetBy: index)
		return currentKeyword[stringIndex]
	}
	
	
	// UISegmentedControl
	// ------------------------------
	// Use the segmented control element to provide a tab-like group of buttons
	// you can get the index of the currently selected segment by accessing the "selectedSegmentIndex" property
	@IBOutlet weak var segmentedControl: UISegmentedControl!
	@IBAction func segmentControlChanged(_ sender: UISegmentedControl) {
		tableView.reloadData()
	}
	
	
	// UISearchBar
	// ------------------------------
	// Add a search bar item to allow users to enter keywords to customize a list of search results
	// this element doesn't inherit from UIControl, so to detect any triggerd events
	// you'll need to add a delegate item that conforms to the "UISearchBarDelegate" protocol
	@IBOutlet weak var searchBar: UISearchBar!
	func setupSearchBar() {
		searchBar.delegate = self
	}
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		if !currentKeyword.isEmpty {
			tableView.reloadData()
		}
	}
	
	
	// Populate table data
	// ------------------------------
	
	// Sections
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String {
		return "Searching \(currentSegment)"
	}
	
	// Rows/cells
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return currentKeyword.count
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)
		cell.textLabel?.text = "Item #\(indexPath.row + 1) - \(getKeywordCharacter(at: indexPath.row))"
		return cell
	}
	
	
}
