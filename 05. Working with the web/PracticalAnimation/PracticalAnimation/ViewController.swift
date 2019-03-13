//
//  ViewController.swift
//  PracticalAnimation
//
//  Created by Román Martínez on 3/12/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		flyingSquare()
	}
	
	
	// Transform and colour animations
	// ------------------------------
	// Use the UIView.animate() method to animate multiple properties of an element at once
	// the final callback is applied after the initial animation ends, you can concatenate extra animations here
	// Use the CGAffineTransform class to easily handle transforms
	func flyingSquare() {
		
		// Create square
		let square = UIView(frame: CGRect(x: 0, y:0, width: 100, height: 100))
		square.backgroundColor = .purple
		view.addSubview(square)
		
		// Animate
		UIView.animate(withDuration: 2.0, animations: {
			square.backgroundColor = .orange
			let scaleTransform = CGAffineTransform(scaleX: 2.0, y: 2.0)
			let rotateTransform = CGAffineTransform(rotationAngle: .pi)
			let translateTransform = CGAffineTransform(translationX: 200, y: 200)
			let comboTransform = scaleTransform.concatenating(rotateTransform).concatenating(translateTransform)
			square.transform = comboTransform
		}) { _ in
			// Revert back
			UIView.animate(withDuration: 2.0, animations: {
				square.backgroundColor = .purple
				square.transform = CGAffineTransform.identity
			})
		}
	}
}
