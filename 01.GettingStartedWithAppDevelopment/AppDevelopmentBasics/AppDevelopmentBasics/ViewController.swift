//
//  ViewController.swift
//  AppDevelopmentBasics
//
//  Created by Román Martínez on 3/4/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	
	// UIViewController Events
	// ------------------------------
	
	// Runs when the view element is loaded into memory
	// do any additional setup after loading the view, typically from a nib
	override func viewDidLoad() {
		super.viewDidLoad()
		testOutput()
		testBreakpoints()
	}
	
	// Triggered when the app is running out of memory
	// use it to dispose of any resources that can be easily re-created
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	
	// Debugging
	// ------------------------------
	
	// Use the 'print' method to output debugging text to the console
	func testOutput() {
		print("Debugging content")
	}
	
	// Use breakpoints to stop the execution of the app at a given point
	// you can then analyse step by step what's happening on the app
	func testBreakpoints() {
		var names = ["Tammy", "Cole"]
		names.removeFirst()
		names.removeFirst()
	}
	
	
	// Interface Builder
	// ------------------------------
	// ctrl+drag elements into a class to add outlets (weak references to the elements)
	// or actions (events triggered when the user interacts with the items on the UI)
	// this way you can set up elements visually using storyboards (Interface Builder), while also allowing you to add functionality programmatically
	// NOTE: for this to work properly, the UIViewController element on the storyboard needs to have a "Class name"
	// matching the name of the class you want to use to control the UI elements
	@IBOutlet weak var mainLabel: UILabel!
	@IBOutlet weak var mainButton: UIButton!
	@IBAction func mainButtonPressed(_ sender: UIButton) {
		mainLabel.text = "Lorem ipsum dolor sit amet"
		mainButton.setTitleColor(.red, for: .normal)
	}
	
	
	// Info.plist
	// ------------------------------
	// Supported Interface Orientations: Lets you control which orientations are supported on phones and tables
	// the UI will rotate to fit a new device orientation only if that orientation is included on this list
	
	
}
