//
//  ViewController.swift
//  Light
//
//  Created by Roman Martinez on 18/09/2017.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    // Properties
    // ------------------------------
    var lightIsOn = true
    
    
    // Methods
    // ------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updateUI()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        lightIsOn = !lightIsOn
        updateUI()
    }
    func updateUI() {
        view.backgroundColor = lightIsOn ? .white : .black
    }
    
}
