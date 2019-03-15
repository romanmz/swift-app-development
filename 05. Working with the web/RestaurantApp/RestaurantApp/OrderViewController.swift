//
//  OrderViewController.swift
//  RestaurantApp
//
//  Created by Román Martínez on 3/15/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit

class OrderViewController: UITableViewController {
	
	
	// Interface Builder outlets
	// ------------------------------
	@IBOutlet weak var submitButton: UIBarButtonItem!
	
	
	// Initialize
	// ------------------------------
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.leftBarButtonItem = editButtonItem
		NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: MenuData.orderUpdatedNotification, object: nil)
		updateUI()
	}
	@objc func updateUI() {
		submitButton.isEnabled = MenuData.order.menuItems.count > 0
		editButtonItem.isEnabled = MenuData.order.menuItems.count > 0
		tableView.reloadData()
	}
	
	
	// Populate content
	// ------------------------------
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return MenuData.order.menuItems.count
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemCell", for: indexPath) as! MenuItemCell
		let menuItem = MenuData.order.menuItems[indexPath.row]
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
	
	
	// Submit orders
	// ------------------------------
	@IBAction func submitButtonTapped(_ sender: UIBarButtonItem) {
		let submitAlert = MenuData.order.getSubmitAlert(callback: receivedTimeEstimate)
		present(submitAlert, animated: true, completion: nil)
	}
	func receivedTimeEstimate(_ prepTime: Int?) {
		DispatchQueue.main.async {
			guard let prepTime = prepTime else {
				self.errorAlert(title: "Network error", message: "There was an error while trying to get the time estimate for your order")
				return
			}
			self.performSegue(withIdentifier: "SubmitOrderSegue", sender: prepTime)
		}
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard segue.identifier == "SubmitOrderSegue",
			let confirmationView = segue.destination as? ConfirmationViewController,
			let prepTime = sender as? Int else { return }
		confirmationView.prepTime = prepTime
	}
	
	
	// Come back
	// ------------------------------
	@IBAction func unwindToOrderView(segue: UIStoryboardSegue) {
		MenuData.order.menuItems = []
	}
	
	
}
