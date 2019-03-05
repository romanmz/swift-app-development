//
//  ViewController.swift
//  AppDevelopmentBasics
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
		testBreakpoints()
	}
	
	// Use breakpoints to stop the execution of the app at a given point
	// you can then analyse step by step what's happening on the app
	func testBreakpoints() {
		var names = ["Tammy", "Cole"]
		names.removeFirst()
		names.removeFirst()
	}
	
	// Triggered when the app is running out of memory
	// use it to dispose of any resources that can be easily re-created
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
}
