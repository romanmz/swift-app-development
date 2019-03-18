//
//  ViewController.swift
//  AppDevelopmentBasics
//
//  Created by Román Martínez on 3/4/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	
	// App Life Cycle
	// ------------------------------
	
	// Counters
	var appLaunched = 0
	var appResignedActive = 0
	var appEnteredBackground = 0
	var appEnteredForeground = 0
	var appBecomeActive = 0
	var appTerminated = 0
	
	// Update labels
	@IBOutlet weak var lifecycleLabels: UILabel!
	func updateLifecycleLabels() {
		lifecycleLabels.text = """
		App launched: \(appLaunched) times
		App resigned active: \(appResignedActive) times
		App entered background: \(appEnteredBackground) times
		App entered foreground: \(appEnteredForeground) times
		App became active: \(appBecomeActive) times
		App terminated: \(appTerminated) times
		"""
	}
	
	
	// UIViewController Life Cycle
	// ------------------------------
	
	// Runs when the view element is first loaded into memory
	override func viewDidLoad() {
		super.viewDidLoad()
		testOutput()
		testBreakpoints()
		updateLifecycleLabels()
	}
	
	// When presenting the view (e.g. on first load, or when navigating to it from another view)
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	// When navigating out of the view
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
	}
	
	// When switching between views:
	// view 2: viewWillAppear
	// view 1: viewWillDisappear
	// view 1: viewDidDisappear
	// view 2: viewDidAppear
	
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
	
	// Requesting permission to access photo library and camera
	// NSPhotoLibraryUsageDescription: Request permission to access to the photo library
	// NSPhotoLibraryAddUsageDescription: Request permission to save images to the photo library
	// NSCameraUsageDescription: Request permission to use the camera
	
	// Secure network activity
	// NSAppTransportSecurity: Lists all security settings
	//     NSAllowsArbitraryLoads: Defines whether or not unsafe (not https) requests are allowed
	
	// Hide status bar:
	// UIStatusBarHidden
	
	
}
