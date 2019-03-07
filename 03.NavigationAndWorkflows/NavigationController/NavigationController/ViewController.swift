//
//  ViewController.swift
//  NavigationController
//
//  Created by Román Martínez on 3/6/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	
	// UINavigationController
	// ------------------------------
	// To add a navigation controller:
	// 1. Drag and drop the "Navigation Controller" item from the elements library
	// 2. Go to the Attributes Inspector and check the "Is initial view controller" box
	// You don't have to add content directly to this view, instead you have to mark another view controller as the root view, to do that:
	// 3. Ctrl+click on the navigation controller, and drag and drop it into the target view, select the "Relationship segue -> root view controller" option
	
	
	// UINavigationBar
	// ------------------------------
	// This elements adds a static grey or coloured bar at the top of the view
	// - A navigation bar element will be added automatically to the navigation controller on the IB, you can't delete it
	// - This bar will be displayed automatically on the root view (always), and on any additional views loaded using segues (only for type "Show (e.g. Push)")
	
	
	// UINavigationItem
	// ------------------------------
	// The "navigation item" element has properties that define what text and navigation buttons will be displayed inside the navigation bar for each individual view
	// All view controllers have their own navigation item on their "navigationItem" property (but remains unused if the navigation bar is not visible)
	// - A navigation item will be added automatically to the root view controller on the IB, you can't delete it
	// - Additional views won't include it automatically on the IB, but you can add it manually to set default settings, or you can edit it programmatically
	
	// Properties
	// - Title: Sets the text to use as title. Empty by default
	// - Back Button: Sets the text to use for the "back" button
	//   If both this and the "Title" property are empty, then the button text will default to "Back"
	//   If this is empty but there's a "Title", then the button text will be the same as the title
	//   NOTE: The back button displayed on a view is not actually defined by that same view, but rather by the source view that triggered the segue
	//         this is because you can get to the same target view from multiple different source views,
	//         so it makes more sense to customize the button based on the source view so users can know exactly to which screen they would be going back to
	
	
	// UIBarButtonItem
	// ------------------------------
	// This is the class used for buttons included on the navigation item
	
	
	// Segues
	// ------------------------------
	
	// Create and setup a "segue" automatically using the Interface Builder:
	// - ctrl+click on an input control element, then drag it into the view controller it should link to
	// - this will automatically set it up so when the user triggers the default event for the input control, the segue will run and load the linked view controller
	
	// Create a "segue" using Interface Builder, then use it programmatically:
	// - ctrl+click from one view controller into another
	// - select the segue element on the storyboard, and use the Attributes Inspector to add an "identifier" name to the segue
	// - to trigger the segue programmatically use the performSegue(withIdentifier:sender:) function
	// - if you want to send data from the source view to the destination view, override the "prepare(for:sender:)" view controller method
	//   remember to check the segue.identifier property to make sure you're targeting the correct segue
	//   and access the target view controller instance with the segue.destination property
	
	
	// Example
	// ------------------------------
	@IBOutlet weak var textField: UITextField!
	@IBAction func buttonPressed(_ sender: UIButton) {
		performSegue(withIdentifier: "segueToDetails", sender: sender)
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard segue.identifier == "segueToDetails" else { return }
		let title = textField.text ?? ""
		segue.destination.navigationItem.title = title.isEmpty ? "(empty)" : title
	}
	
	
}
