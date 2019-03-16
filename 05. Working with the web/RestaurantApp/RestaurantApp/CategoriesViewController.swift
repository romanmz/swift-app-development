//
//  CategoriesViewController.swift
//  RestaurantApp
//
//  Created by Román Martínez on 3/14/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit

class CategoriesViewController: UITableViewController {
	
	
	// Properties
	// ------------------------------
	var categories: [String]! {
		didSet {
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}
	
	
	// Initialize
	// ------------------------------
	override func viewDidLoad() {
		super.viewDidLoad()
		NotificationCenter.default.addObserver(self, selector: #selector(updateCategories), name: MenuData.menuUpdatedNotification, object: nil)
		updateCategories()
	}
	@objc func updateCategories() {
		categories = MenuData.categories
	}
	
	
	// Populate content
	// ------------------------------
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return categories.count
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
		cell.textLabel?.text = categories[indexPath.row].capitalized
		return cell
	}
	
	
	// Segues
	// ------------------------------
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard segue.identifier == "ShowCategorySegue",
			let categoryView = segue.destination as? CategoryViewController,
			let selectedIndex = tableView.indexPathForSelectedRow else { return }
		categoryView.category = categories[selectedIndex.row]
	}
	
	
}
