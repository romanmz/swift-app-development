//
//  ViewController.swift
//  GettingStarted
//
//  Created by Roman Martinez on 18/09/2017.
//
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var names = ["Tammy", "Cole"]
        names.removeFirst()
        names.removeFirst()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

