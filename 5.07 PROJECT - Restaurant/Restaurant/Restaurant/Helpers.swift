//
//  Helpers.swift
//  Restaurant
//
//  Created by Roman Martinez on 28/9/17.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {
	func errorAlert(title: String?, message: String?) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
		alert.addAction(dismissAction)
		present(alert, animated: true, completion: nil)
	}
}
