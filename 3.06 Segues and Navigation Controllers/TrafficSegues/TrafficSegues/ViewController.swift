//
//  ViewController.swift
//  TrafficSegues
//
//  Created by Roman Martinez on 20/09/2017.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var toggle: UISwitch!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func yellowButtonTapped(_ sender: Any) {
		if toggle.isOn {
			performSegue(withIdentifier: "YellowSegue", sender: nil)
		}
	}
	@IBAction func greenButtonTapped(_ sender: Any) {
		if toggle.isOn {
			performSegue(withIdentifier: "GreenSegue", sender: nil)
		}
	}
	
	
}
