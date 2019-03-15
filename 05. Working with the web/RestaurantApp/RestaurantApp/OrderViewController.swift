//
//  OrderViewController.swift
//  RestaurantApp
//
//  Created by Román Martínez on 3/15/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit

class OrderViewController: UITableViewController {
	
	
	// Properties
	// ------------------------------
	var order: Order! {
		didSet {
			tableView.reloadData()
		}
	}
	
	
	// Initialize
	// ------------------------------
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.leftBarButtonItem = editButtonItem
		NotificationCenter.default.addObserver(self, selector: #selector(updateOrder), name: MenuData.orderUpdatedNotification, object: nil)
		updateOrder()
	}
	@objc func updateOrder() {
		order = MenuData.order
	}
	
	
	// Populate content
	// ------------------------------
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return order.menuItems.count
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemCell", for: indexPath) as! MenuItemCell
		let menuItem = order.menuItems[indexPath.row]
		cell.update(with: menuItem, at: indexPath, in: self)
		return cell
	}
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 80
	}
	
	
	// Edit order
	// ------------------------------
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			MenuData.order.menuItems.remove(at: indexPath.row)
		}
	}
	
	
}
