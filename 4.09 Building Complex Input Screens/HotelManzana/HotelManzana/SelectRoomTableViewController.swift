//
//  SelectRoomTableViewController.swift
//  HotelManzana
//
//  Created by Roman Martinez on 26/9/17.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import UIKit

protocol SelectRoomTableViewControllerDelegate {
	func didSelect(roomType: RoomType)
}

class SelectRoomTableViewController: UITableViewController {
	var delegate: SelectRoomTableViewControllerDelegate?
	var roomType: RoomType?
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return RoomType.all.count
		}
        return 0
    }
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "RoomTypeCell", for: indexPath)
		let room = RoomType.all[ indexPath.row ]
		cell.textLabel?.text = room.name
		cell.detailTextLabel?.text = "$ \(room.price).00"
		if room == roomType {
			cell.accessoryType = .checkmark
		} else {
			cell.accessoryType = .none
		}
		return cell
	}
	
	// Table delegate
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		roomType = RoomType.all[indexPath.row]
		delegate?.didSelect(roomType: roomType!)
		tableView.reloadData()
	}
}
