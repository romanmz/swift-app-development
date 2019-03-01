//
//  MenuTableViewController.swift
//  Restaurant
//
//  Created by Roman Martinez on 28/9/17.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
	
	
	// Properties
	// ------------------------------
	var category: String?
	var menuItems: [MenuItem] = []
	
	
	// Methods
	// ------------------------------
	override func viewDidLoad() {
		super.viewDidLoad()
		NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: MenuController.menuDataUpdatedNotification, object: nil)
		updateUI()
	}
	override func encodeRestorableState(with coder: NSCoder) {
		super.encodeRestorableState(with: coder)
		guard let category = category else { return }
		coder.encode(category, forKey: "category")
	}
	override func decodeRestorableState(with coder: NSCoder) {
		super.decodeRestorableState(with: coder)
		category = coder.decodeObject(forKey: "category") as? String
		updateUI()
	}
	@objc func updateUI() {
		guard let category = category else { return }
		title = category.capitalized
		menuItems = MenuController.shared.items(forCategory: category) ?? []
		tableView.reloadData()
	}
	/*
	func updateMenuList() {
		MenuController.shared.fetchMenuItems(for: category) { (menuItems) in
			DispatchQueue.main.async {
				self.updateUI(with: menuItems)
			}
		}
	}
    func updateUI(with menuItems: [MenuItem]?) {
		if let menuItems = menuItems {
			self.menuItems = menuItems
		} else {
			self.menuItems.removeAll()
			self.errorAlert(title: "Network Error", message: "There was an error while trying to fetch the list of menu items, please try again")
		}
		self.tableView.reloadData()
    }
	*/
	
	
	// Table Cells
	// ------------------------------
	override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell", for: indexPath) as! MenuItemTableViewCell
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
		if segue.identifier == "ShowItemDetails" {
			guard let viewController = segue.destination as? MenuItemDetailViewController else { return }
			guard let selectedIndex = tableView.indexPathForSelectedRow else { return }
			viewController.menuItem = menuItems[selectedIndex.row]
		}
	}
	
	
}
