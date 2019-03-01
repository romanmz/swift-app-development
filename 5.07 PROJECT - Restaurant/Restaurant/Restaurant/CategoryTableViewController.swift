//
//  CategoryTableViewController.swift
//  Restaurant
//
//  Created by Roman Martinez on 28/9/17.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {
	
	
	// Properties
	// ------------------------------
	var categories: [String] = []
	
	
	// Methods
	// ------------------------------
	override func viewDidLoad() {
        super.viewDidLoad()
		NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: MenuController.menuDataUpdatedNotification, object: nil)
		updateUI()
	}
	@objc func updateUI() {
		categories = MenuController.shared.categories
		self.tableView.reloadData()
    }
	/*
	override func viewDidAppear(_ animated: Bool) {
		if categories.isEmpty {
			updateCategoriesList()
		}
	}
	func updateCategoriesList() {
		MenuController.shared.fetchCategories { (categories) in
			DispatchQueue.main.async {
				self.updateUI(with: categories)
			}
		}
	}
	func updateUI(with categories: [String]?) {
		if let categories = categories {
			self.categories = categories
		} else {
			self.categories.removeAll()
			self.errorAlert(title: "Network Error", message: "There was an error while trying to fetch the list of categories, please try again")
		}
		self.tableView.reloadData()
	*/
	
	
	// Table Cells
	// ------------------------------
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
		let category = categories[indexPath.row]
		cell.textLabel?.text = category.capitalized
		return cell
	}
	
	
	// Segues
	// ------------------------------
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "ShowCategory" {
			guard let viewController = segue.destination as? MenuTableViewController else { return }
			guard let selectedIndex = tableView.indexPathForSelectedRow else { return }
			viewController.category = categories[selectedIndex.row]
		}
	}
	
	
}
