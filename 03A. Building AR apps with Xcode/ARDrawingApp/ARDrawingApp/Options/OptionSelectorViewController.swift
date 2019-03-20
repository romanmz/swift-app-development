//
//  OptionSelectorViewController.swift
//  ARDrawingApp
//
//  Created by Román Martínez on 3/19/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit


struct Option {
	let title: String
	let callback: ()->Void
	let showIndicator: Bool
	init(title: String, callback: @escaping ()->Void, showIndicator: Bool = false) {
		self.title = title
		self.callback = callback
		self.showIndicator = showIndicator
	}
}


class OptionSelectorViewController: UITableViewController {
	
	
	// Init with list of options
	// ------------------------------
	private let options: [Option]
	init(options: [Option]) {
		self.options = options
		super.init(style: .plain)
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	// Show list of options
	// ------------------------------
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.reloadData()
	}
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return options.count
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .default, reuseIdentifier: "Option")
		let option = options[indexPath.row]
		cell.textLabel?.text = option.title
		cell.accessoryType = option.showIndicator ? .disclosureIndicator : .none
		return cell
	}
	
	
	// Select option
	// ------------------------------
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		let option = options[indexPath.row]
		option.callback()
	}
	
	
}
