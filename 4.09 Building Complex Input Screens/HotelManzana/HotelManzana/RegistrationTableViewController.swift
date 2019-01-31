//
//  RegistrationTableViewController.swift
//  HotelManzana
//
//  Created by Roman Martinez on 27/9/17.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import UIKit

class RegistrationTableViewController: UITableViewController {
	
	
	var registrations: [Registration] = [
		Registration(firstName: "Dave", lastName: "Smith", emailAddress: "", checkInDate: Date(), checkOutDate: Date(), numberOfAdults: 1, numberOfChildren: 1, roomType: RoomType.all[0], wifi: true),
		Registration(firstName: "Samantha", lastName: "Martinez", emailAddress: "sam@email.com", checkInDate: Date(), checkOutDate: Date(), numberOfAdults: 3, numberOfChildren: 0, roomType: RoomType.all[2], wifi: true),
		Registration(firstName: "John", lastName: "Evans", emailAddress: "", checkInDate: Date(), checkOutDate: Date(), numberOfAdults: 2, numberOfChildren: 1, roomType: RoomType.all[1], wifi: false),
	]
	
	
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
	}
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return registrations.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegistrationCell", for: indexPath)
		let registration = registrations[indexPath.row]
		cell.textLabel?.text = "\(registration.firstName) \(registration.lastName)"
		cell.detailTextLabel?.text = "\(Registration.getFormattedDate(registration.checkInDate)) - \(Registration.getFormattedDate(registration.checkOutDate)): \(registration.roomType.name)"
		return cell
    }
	
	@IBAction func unwindFromAddRegistration(segue: UIStoryboardSegue) {
		guard let viewController = segue.source as? AddRegistrationTableViewController else { return }
		guard let newRegistration = viewController.registration else { return }
		registrations.append(newRegistration)
		tableView.reloadData()
	}
	
	
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
