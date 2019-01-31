
import UIKit

class EmployeeDetailTableViewController: UITableViewController, UITextFieldDelegate, EmployeeTypeDelegate {

    struct PropertyKeys {
        static let unwindToListIndentifier = "UnwindToListSegue"
    }
	
	
	// Properties
	var employee: Employee?
	var employeeType: EmployeeType?
	var isEditingBirthday = false {
		didSet {
			tableView.beginUpdates()
			tableView.endUpdates()
		}
	}
	
	// IB Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var employeeTypeLabel: UILabel!
	@IBOutlet weak var dobDatePicker: UIDatePicker!
	
	
	// Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    func updateView() {
        if let employee = employee {
            navigationItem.title = employee.name
            nameTextField.text = employee.name
			
			dobDatePicker.date = employee.dateOfBirth
			updateDobLabel()
			
			employeeTypeLabel.text = employee.employeeType.description()
            employeeTypeLabel.textColor = .black
        } else {
            navigationItem.title = "New Employee"
        }
    }
	
	
	func updateDobLabel() {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .none
		dobLabel.textColor = .black
		dobLabel.text = dateFormatter.string(from: dobDatePicker.date)
	}
	@IBAction func dobDatePickerChanged(_ sender: UIDatePicker) {
		updateDobLabel()
	}
	@IBAction func saveButtonTapped(_ sender: Any) {
        if let name = nameTextField.text {
			let employeeType = self.employeeType ?? .exempt
            employee = Employee(name: name, dateOfBirth: dobDatePicker.date, employeeType: employeeType)
            performSegue(withIdentifier: PropertyKeys.unwindToListIndentifier, sender: self)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        employee = nil
        performSegue(withIdentifier: PropertyKeys.unwindToListIndentifier, sender: self)
    }
	
	
	// Table View Delegate
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.section == 0 && indexPath.row == 2 {
			return isEditingBirthday ? dobDatePicker.intrinsicContentSize.height : 0.0
		}
		return 44.0
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		if indexPath.section == 0 && indexPath.row == 1 {
			isEditingBirthday = !isEditingBirthday
			updateDobLabel()
		}
	}
	
	
	// Employee Type Delegate
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "SegueToEmployeeTypeTable" {
			guard let viewController = segue.destination as? EmployeeTypeTableViewController else { return }
			viewController.delegate = self
		}
	}
	func didSelect(employeeType: EmployeeType) {
		self.employeeType = employeeType
		employeeTypeLabel.text = employeeType.description()
		employeeTypeLabel.textColor = .black
	}
	
	
    // MARK: - Text Field Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }

}
