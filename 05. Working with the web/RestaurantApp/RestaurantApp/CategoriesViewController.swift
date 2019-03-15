//
//  CategoriesViewController.swift
//  RestaurantApp
//
//  Created by Román Martínez on 3/14/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit

class CategoriesViewController: UITableViewController {
	
	
	// Initialize
	// ------------------------------
	override func viewDidLoad() {
		super.viewDidLoad()
		NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: MenuData.menuUpdatedNotification, object: nil)
	}
	
	
	// Populate content
	// ------------------------------
	@objc func updateUI() {
		tableView.reloadData()
	}
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return MenuData.categories.count
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
		cell.textLabel?.text = MenuData.categories[indexPath.row]
		return cell
	}
}
