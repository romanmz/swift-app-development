//
//  ViewController.swift
//  Login
//
//  Created by Roman Martinez on 20/09/2017.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	
	@IBOutlet weak var fieldUsername: UITextField!
	@IBOutlet weak var fieldPassword: UITextField!
	@IBOutlet weak var buttonForgotUsername: UIButton!
	@IBOutlet weak var buttonForgotPassword: UIButton!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let sender = sender as? UIButton else { return }
		let navTitle: String
		if sender == buttonForgotUsername {
			navTitle = "Forgot username"
		} else if sender == buttonForgotPassword {
			navTitle = "Forgot password"
		} else if let username = fieldUsername.text, !username.isEmpty {
			navTitle = username
		} else {
			navTitle = "Dashboard"
		}
		segue.destination.navigationItem.title = navTitle
	}
	
	@IBAction func tappedForgotUsername(_ sender: UIButton) {
		performSegue(withIdentifier: "segueToDashboard", sender: sender)
	}
	@IBAction func tappedForgotPassword(_ sender: UIButton) {
		performSegue(withIdentifier: "segueToDashboard", sender: sender)
	}
	
}
