//
//  Helpers.swift
//  RestaurantApp
//
//  Created by Román Martínez on 3/15/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
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
