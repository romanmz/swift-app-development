//
//  ViewController.swift
//  AppEventCount
//
//  Created by Roman Martinez on 21/09/2017.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var didLaunch: UILabel!
	@IBOutlet weak var willResignActive: UILabel!
	@IBOutlet weak var didEnterBackground: UILabel!
	@IBOutlet weak var willEnterForeground: UILabel!
	@IBOutlet weak var didBecomeActive: UILabel!
	@IBOutlet weak var willTerminate: UILabel!
	
	var launchCount = 0
	var resignActiveCount = 0
	var enterBackgroundCount = 0
	var enterForegroundCount = 0
	var becomeActiveCount = 0
	var terminateCount = 0
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		updateView()
	}
	func updateView() {
		didLaunch.text = "App launched: \(launchCount) times"
		willResignActive.text = "App will resign active: \(resignActiveCount) times"
		didEnterBackground.text = "App entered background: \(enterBackgroundCount) times"
		willEnterForeground.text = "App will enter foreground: \(enterForegroundCount) times"
		didBecomeActive.text = "App became active: \(becomeActiveCount) times"
		willTerminate.text = "App will terminate: \(terminateCount) times"
	}
	
	
}
