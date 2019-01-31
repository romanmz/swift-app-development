//
//  ViewController.swift
//  Contest
//
//  Created by Roman Martinez on 27/9/17.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	
	@IBOutlet weak var emailField: UITextField!
	@IBAction func submitButtonTapped(_ sender: UIButton) {
		let email = emailField.text ?? ""
		if email.isEmpty {
			UIView.animate(withDuration: 0.05, animations: {
				self.emailField.transform = CGAffineTransform(rotationAngle: 8 * 0.0175)
			}, completion: { (_) in
				UIView.animate(withDuration: 0.1, animations: {
					self.emailField.transform = CGAffineTransform(rotationAngle: -8 * 0.0175)
				}, completion: { (_) in
					UIView.animate(withDuration: 0.05, animations: {
						self.emailField.transform = CGAffineTransform.identity
					})
				})
			})
		} else {
			performSegue(withIdentifier: "Success", sender: self)
		}
	}
	
	
}
