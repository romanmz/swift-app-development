//
//  OptionSelectorViewController.swift
//  ARDrawingApp
//
//  Created by Román Martínez on 3/19/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit

class OptionSelectorViewController: UITableViewController {
	
	
	// Init with list of options
	// ------------------------------
	private let options: [MenuOption]
	private let onSelectCallback: ((MenuOption)->Void)?
	init(options: [MenuOption], onSelect: ((MenuOption)->Void)?) {
		self.options = options
		self.onSelectCallback = onSelect
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
		cell.textLabel?.text = option.rawValue
		return cell
	}
	
	
	// Select option
	// ------------------------------
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		let option = options[indexPath.row]
		onSelectCallback?(option)
	}
	
	
}
