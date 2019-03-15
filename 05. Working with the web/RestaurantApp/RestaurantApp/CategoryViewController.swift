//
//  CategoryViewController.swift
//  RestaurantApp
//
//  Created by Román Martínez on 3/15/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit

class CategoryViewController: UITableViewController {
	
	
	// Properties
	// ------------------------------
	var category: String!
	var menuItems: [MenuItem]! {
		didSet {
			tableView.reloadData()
		}
	}
	
	
	// Initialize
	// ------------------------------
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = category.capitalized
		NotificationCenter.default.addObserver(self, selector: #selector(updateMenuItems), name: MenuData.menuUpdatedNotification, object: nil)
		updateMenuItems()
	}
	@objc func updateMenuItems() {
		menuItems = MenuData.getMenuItems(withCategory: category)
	}
	
	
	// Populate content
	// ------------------------------
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return menuItems.count
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell", for: indexPath) as! MenuItemCell
		let menuItem = menuItems[indexPath.row]
		cell.update(with: menuItem, at: indexPath, in: self)
		return cell
	}
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 80
	}
	
	
	// Segues
	// ------------------------------
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard segue.identifier == "ShowMenuItemSegue",
			let menuItemView = segue.destination as? MenuItemViewController,
			let selectedIndex = tableView.indexPathForSelectedRow else { return }
		menuItemView.menuItem = menuItems[selectedIndex.row]
	}
	
	
}
