import UIKit

class AthleteTableViewController: UITableViewController {
	
	
	// PROPERTIES
	// ------------------------------
	var athletes: [Athlete] = []
	
	
	// METHODS
	// ------------------------------
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if
			segue.identifier == "EditAthlete",
			let formController = segue.destination as? AthleteFormViewController,
			let indexPath = tableView.indexPathForSelectedRow {
			formController.athlete = athletes[indexPath.row]
		}
	}
	
	@IBAction func unwindToTableView(_ segue: UIStoryboardSegue) {
		guard let formView = segue.source as? AthleteFormViewController else { return }
		guard let athlete = formView.athlete else { return }
		
		if let indexPath = tableView.indexPathForSelectedRow {
			athletes.remove(at: indexPath.row)
			athletes.insert(athlete, at: indexPath.row)
			tableView.deselectRow(at: indexPath, animated: true)
		} else {
			athletes.append(athlete)
		}
	}
	
	
	// MARK: - Table view data source
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return athletes.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "AthleteCell", for: indexPath)
		let athlete = athletes[indexPath.row]
		cell.textLabel?.text = athlete.name
		cell.detailTextLabel?.text = athlete.description
		return cell
    }
	
	
}
