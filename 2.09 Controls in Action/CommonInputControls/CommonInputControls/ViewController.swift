//
//  ViewController.swift
//  CommonInputControls
//
//  Created by Roman Martinez on 19/09/2017.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var button: UIButton!
	@IBOutlet weak var toggle: UISwitch!
	@IBOutlet weak var slider: UISlider!
	@IBOutlet weak var userLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
	}
	
	@IBAction func buttonTapped(_ sender: UIButton) {
		print("Button was tapped!")
		printToggleStatus()
		printSliderStatus()
	}
	
	@IBAction func switchToggled(_ sender: UISwitch) {
		printToggleStatus()
	}
	
	@IBAction func sliderMoved(_ sender: UISlider) {
		printSliderStatus()
	}
	
	@IBAction func textChanged(_ sender: UITextField) {
		if let newText = sender.text {
			userLabel.text = newText
			print(newText)
		}
	}
	
	@IBAction func onSingleTap(_ sender: UITapGestureRecognizer) {
		let location = sender.location(in: view)
		print(location)
	}
	
	func printToggleStatus() {
		if toggle.isOn {
			print("Switch is on")
		} else {
			print("Switch is off")
		}
	}
	func printSliderStatus() {
		print(slider.value)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}
