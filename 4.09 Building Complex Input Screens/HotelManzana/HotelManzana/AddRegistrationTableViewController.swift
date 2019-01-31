//
//  AddRegistrationTableViewController.swift
//  HotelManzana
//
//  Created by Roman Martinez on 26/9/17.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import UIKit

class AddRegistrationTableViewController: UITableViewController, SelectRoomTableViewControllerDelegate {
	
	
	// Properties
	// --------------------------------------------------
	let checkInDatePickerCellIndexPath = IndexPath(row: 1, section: 1)
	let checkOutDatePickerCellIndexPath = IndexPath(row: 3, section: 1)
	var isCheckInDatePickerShown: Bool = false {
		didSet {
			checkInDatePicker.isHidden = !isCheckInDatePickerShown
		}
	}
	var isCheckOutDatePickerShown: Bool = false {
		didSet {
			checkOutDatePicker.isHidden = !isCheckOutDatePickerShown
		}
	}
	var roomType: RoomType?
	var registration: Registration? {
		guard let roomType = roomType else { return nil }
		let firstName = firstNameTextField.text ?? ""
		let lastName = lastNameTextField.text ?? ""
		let emailAddress = emailAddressTextField.text ?? ""
		let checkIn = checkInDatePicker.date
		let checkOut = checkOutDatePicker.date
		let numberOfAdults = Int(numberOfAdultsStepper.value)
		let numberOfChildren = Int(numberOfChildrenStepper.value)
		let hasWifi = wifiSwitch.isOn
		return Registration(firstName: firstName, lastName: lastName, emailAddress: emailAddress, checkInDate: checkIn, checkOutDate: checkOut, numberOfAdults: numberOfAdults, numberOfChildren: numberOfChildren, roomType: roomType, wifi: hasWifi)
	}
	
	@IBOutlet weak var firstNameTextField: UITextField!
	@IBOutlet weak var lastNameTextField: UITextField!
	@IBOutlet weak var emailAddressTextField: UITextField!
	
	@IBOutlet weak var checkInDateLabel: UILabel!
	@IBOutlet weak var checkInDatePicker: UIDatePicker!
	@IBOutlet weak var checkOutDateLabel: UILabel!
	@IBOutlet weak var checkOutDatePicker: UIDatePicker!
	
	@IBOutlet weak var numberOfAdultsLabel: UILabel!
	@IBOutlet weak var numberOfAdultsStepper: UIStepper!
	@IBOutlet weak var numberOfChildrenLabel: UILabel!
	@IBOutlet weak var numberOfChildrenStepper: UIStepper!
	
	@IBOutlet weak var wifiSwitch: UISwitch!
	@IBOutlet weak var roomTypeLabel: UILabel!
	
	@IBOutlet weak var resultsRoomType: UILabel!
	
	// Select Room Delegate
	func didSelect(roomType: RoomType) {
		self.roomType = roomType
		updateRoomType()
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)
		if segue.identifier == "SelectRoomType" {
			guard let viewController = segue.destination as? SelectRoomTableViewController else { return }
			viewController.delegate = self
			viewController.roomType = roomType
		}
	}
	
	
	// Methods
	// --------------------------------------------------
	override func viewDidLoad() {
        super.viewDidLoad()
		
		// Set minimum date for check-in
		let midnightToday = Calendar.current.startOfDay(for: Date())
		checkInDatePicker.minimumDate = midnightToday
		checkInDatePicker.date = midnightToday
		
		// Setup steppers
		numberOfAdultsStepper.value = 1
		numberOfAdultsStepper.maximumValue = 10
		numberOfChildrenStepper.value = 0
		numberOfChildrenStepper.maximumValue = 10
		
		// update labels
		updateDateViews()
		updateStepperViews()
		updateRoomType()
    }
	
	
	func updateDateViews() {
		// Set minimum date for check-out
		checkOutDatePicker.minimumDate = checkInDatePicker.date.addingTimeInterval((24 * 60 * 60))
		
		// Update labels
		checkInDateLabel.text = Registration.getFormattedDate(checkInDatePicker.date)
		checkOutDateLabel.text = Registration.getFormattedDate(checkOutDatePicker.date)
	}
	func updateStepperViews() {
		numberOfAdultsLabel.text = "\(Int(numberOfAdultsStepper.value))"
		numberOfChildrenLabel.text = "\(Int(numberOfChildrenStepper.value))"
	}
	func updateRoomType() {
		if let roomType = roomType {
			roomTypeLabel.text = roomType.name
		} else {
			roomTypeLabel.text = "Not Set"
		}
	}
	
	
	@IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
	@IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
		updateDateViews()
	}
	@IBAction func steppersChanged(_ sender: UIStepper) {
		updateStepperViews()
	}
	
	// Table View Delegate Methods
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch indexPath {
			case checkInDatePickerCellIndexPath:
				return isCheckInDatePickerShown ? 216.0 : 0.0
			case checkOutDatePickerCellIndexPath:
				return isCheckOutDatePickerShown ? 216.0 : 0.0
			default:
				return 44.0
		}
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		// Disable highlight
		if let selectedCell = tableView.cellForRow(at: indexPath) {
			selectedCell.selectionStyle = .none
		}
		
		// Toggle date pickers
		var nextIndexPath = indexPath
		nextIndexPath.row += 1
		switch nextIndexPath {
			case checkInDatePickerCellIndexPath:
				isCheckInDatePickerShown = !isCheckInDatePickerShown
				isCheckOutDatePickerShown = false
				tableView.beginUpdates()
				tableView.endUpdates()
			case checkOutDatePickerCellIndexPath:
				isCheckInDatePickerShown = false
				isCheckOutDatePickerShown = !isCheckOutDatePickerShown
				tableView.beginUpdates()
				tableView.endUpdates()
			default:
				break
		}
	}
	
	
}
