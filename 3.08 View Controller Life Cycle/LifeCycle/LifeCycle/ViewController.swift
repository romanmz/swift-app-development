//
//  ViewController.swift
//  LifeCycle
//
//  Created by Roman Martinez on 21/09/2017.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		print("ViewController: viewDidLoad")
	}
	override func viewWillAppear(_ animated: Bool) {
		//
		print("ViewController: viewWillAppear")
	}
	override func viewDidAppear(_ animated: Bool) {
		//
		print("ViewController: viewDidAppear")
	}
	override func viewWillDisappear(_ animated: Bool) {
		//
		print("ViewController: viewWillDisappear")
	}
	override func viewDidDisappear(_ animated: Bool) {
		//
		print("ViewController: viewDidDisappear")
	}
	

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

