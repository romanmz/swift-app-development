//
//  AthleteFormViewController.swift
//  FavoriteAthlete
//
//  Created by Roman Martinez on 22/09/2017.
//
//

import UIKit

class AthleteFormViewController: UIViewController {
	
	
	// PROPERTIES
	// ------------------------------
	var athlete: Athlete?
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var ageTextField: UITextField!
	@IBOutlet weak var leagueTextField: UITextField!
	@IBOutlet weak var teamTextField: UITextField!
	
	
	// METHODS
	// ------------------------------
	override func viewDidLoad() {
		super.viewDidLoad()
		updateView()
	}
	func updateView() {
		if let currentAthlete = athlete {
			nameTextField.text = currentAthlete.name
			ageTextField.text = "\(currentAthlete.age)"
			leagueTextField.text = currentAthlete.league
			teamTextField.text = currentAthlete.team
		} else {
			nameTextField.text = nil
			ageTextField.text = nil
			leagueTextField.text = nil
			teamTextField.text = nil
		}
	}
	@IBAction func saveButtonTapped(_ sender: UIButton) {
		guard let name = nameTextField.text,
			let ageString = ageTextField.text,
			let age = Int(ageString),
			let league = leagueTextField.text,
			let team = teamTextField.text else { return }
		athlete = Athlete(name: name, age: age, league: league, team: team)
		
		performSegue(withIdentifier: "BackToTable", sender: self)
	}
	
	
}
