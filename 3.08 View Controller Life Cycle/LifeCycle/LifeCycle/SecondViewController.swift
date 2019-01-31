//
//  SecondViewController.swift
//  LifeCycle
//
//  Created by Roman Martinez on 21/09/2017.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		print("SecondViewController: viewDidLoad")
	}
	override func viewWillAppear(_ animated: Bool) {
		//
		print("SecondViewController: viewWillAppear")
	}
	override func viewDidAppear(_ animated: Bool) {
		//
		print("SecondViewController: viewDidAppear")
	}
	override func viewWillDisappear(_ animated: Bool) {
		//
		print("SecondViewController: viewWillDisappear")
	}
	override func viewDidDisappear(_ animated: Bool) {
		//
		print("SecondViewController: viewDidDisappear")
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
