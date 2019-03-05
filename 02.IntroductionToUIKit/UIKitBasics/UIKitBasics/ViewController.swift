//
//  ViewController.swift
//  UIKitBasics
//
//  Created by Román Martínez on 3/4/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		// ++++++++++++++++++++++++++++++
		programmaticEvents()
	}
	
	
	// Input controls
	// ------------------------------
	@IBAction func buttonPressed(_ sender: UIButton) {
		print("The button was tapped!")
	}
	@IBAction func switchToggled(_ sender: UISwitch) {
		print("The switch is now \(sender.isOn ? "on" : "off")!")
	}
	@IBAction func sliderMoved(_ sender: UISlider) {
		print("The slider value is \(sender.value)!")
	}
	@IBAction func textChanged(_ sender: UITextField) {
		var text = sender.text ?? "(empty)"
		if text.isEmpty { text = "(empty)" }
		print("The text is now \(text)!")
	}
	
	
	// Bind callbacks to input control events programmatically
	// ------------------------------
	// Use .addTarget() to bind callback functions to events triggered by input elements
	// the callback function needs to be marked as @objc
	@IBOutlet weak var button: UIButton!
	func programmaticEvents() {
		button.addTarget(self, action: #selector(buttonAlsoPressed), for: .touchUpInside)
	}
	@objc func buttonAlsoPressed() {
		print("This action was added programmatically!")
	}
	
	
	// Gesture recognizers
	// ------------------------------
	// Use the "Gesture Recognizer" elements to detect specific gestures done by the user (tap, double tap, swipe, etc…)
	// they are shortcuts so you don't have to manually track down the touch movements using the touchesBegan, touchesMoved, etc… methods
	@IBAction func onSingleTap(_ sender: UITapGestureRecognizer) {
		let location = sender.location(in: view)
		print("Single tap gesture on: \(location)")
	}
	
	
}
