//
//  OrderTableViewController.swift
//  Restaurant
//
//  Created by Roman Martinez on 28/9/17.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import UIKit

class OrderTableViewController: UITableViewController {
	
	
	// Properties
	// ------------------------------
	var orderMinutes: Int?
	
	// Outlets
	@IBOutlet weak var submitButton: UIBarButtonItem!
	
	
	// Methods
	// ------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationItem.leftBarButtonItem = self.editButtonItem
		// Auto refresh when order instance is updated
		NotificationCenter.default.addObserver(tableView, selector: #selector(UITableView.reloadData), name: MenuController.orderUpdatedNotification, object: nil)
		updateUI()
    }
	func updateUI() {
		if MenuController.shared.order.menuItems.count > 0 {
			submitButton.isEnabled = true
			editButtonItem.isEnabled = true
		} else {
			submitButton.isEnabled = false
			editButtonItem.isEnabled = false
		}
	}
	
	
	// Table Cells
	// ------------------------------
	override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuController.shared.order.menuItems.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell", for: indexPath) as! MenuItemTableViewCell
		let menuItem = MenuController.shared.order.menuItems[indexPath.row]
		cell.update(with: menuItem, at: indexPath, in: self)
		return cell
    }
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 80
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	
	// Deleting Items
	// ------------------------------
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
			MenuController.shared.order.menuItems.remove(at: indexPath.row)
			updateUI()
        }
    }
	
	
	// Submitting Orders
	// ------------------------------
	@IBAction func submitButtonTapped(_ sender: UIBarButtonItem) {
		let totalCost: Double = MenuController.shared.order.menuItems.reduce(0) { $0 + $1.price }
		let formattedCost = String(format: "$%.2f", totalCost)
		let alert = UIAlertController(title: "Confirm Order", message: "You are about to submit your order with a total of \(formattedCost)", preferredStyle: .alert)
		let submitAction = UIAlertAction(title: "Submit", style: .default) { (alertAction) in self.submitOrder() }
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		alert.addAction(submitAction)
		alert.addAction(cancelAction)
		present(alert, animated: true, completion: nil)
	}
	func submitOrder() {
		let menuIds: [Int] = MenuController.shared.order.menuItems.map { $0.id }
		MenuController.shared.submitOrder(menuIds: menuIds, completion: { (minutes) in
            DispatchQueue.main.async {
                if let resultMinutes = minutes {
                    self.orderMinutes = resultMinutes
                    self.performSegue(withIdentifier: "OrderConfirmationSegue", sender: self)
                } else {
                    self.errorAlert(title: "Network Error", message: "There was an error while trying to submit your order, please try again")
                }
            }
		})
	}
	
	
	// Segues
	// ------------------------------
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "OrderConfirmationSegue" {
			guard let minutes = orderMinutes,
				let viewController = segue.destination as? OrderConfirmationViewController else { return }
			viewController.minutes = minutes
		}
	}
	@IBAction func unwindToOrderView(segue: UIStoryboardSegue) {
		if segue.identifier == "DismissConfirmation" {
			MenuController.shared.order.menuItems.removeAll()
			updateUI()
		}
	}
	
	
}
