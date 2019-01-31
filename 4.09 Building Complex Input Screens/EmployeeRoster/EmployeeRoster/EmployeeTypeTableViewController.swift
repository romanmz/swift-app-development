//
//  EmployeeTypeTableViewController.swift
//  EmployeeRoster
//
//  Created by Roman Martinez on 27/9/17.
//

import UIKit

protocol EmployeeTypeDelegate {
	func didSelect(employeeType: EmployeeType)
}

class EmployeeTypeTableViewController: UITableViewController {
	
	
	var selectedEmployeeType: EmployeeType?
	var delegate: EmployeeTypeDelegate?
	
	
	// MARK: - Table view data source
	override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EmployeeType.all.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeTypeCell", for: indexPath)
		let employeeType = EmployeeType.all[indexPath.row]
		cell.textLabel?.text = employeeType.description()
		if employeeType == selectedEmployeeType {
			cell.accessoryType = .checkmark
		} else {
			cell.accessoryType = .none
		}
		return cell
    }
	
	// MARK: - Table view delegate
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		let employeeType = EmployeeType.all[indexPath.row]
		selectedEmployeeType = employeeType
		delegate?.didSelect(employeeType: employeeType)
		tableView.reloadData()
	}
	
	
}
