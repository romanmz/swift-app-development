//
//  TabBarController.swift
//  TabBarController
//
//  Created by Román Martínez on 3/7/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
	
	
	// UITabBarController
	// ------------------------------
	// To add a tab bar controller:
	// 1. Drag and drop the "Tab Bar Controller" item from the elements library
	// 2. Go to the Attributes Inspector and check the "Is initial view controller" box
	// You don't add content directly to this view, instead you have to link multiple view controllers, to do that:
	// 3. Ctrl+click on the navigation controller, and drag and drop it into one of the target views, select the "Relationship segue -> view controllers" option
	
	// Managing the linked view controllers programmatically:
	// - viewControllers: Contains a list of all the view controllers included on the tab navigation
	// - setViewControllers(_:animated:): Lets you update the list of included view controllers
	
	
	// UITabBar
	// ------------------------------
	// This element adds a static grey or coloured bar at the bottom of the view
	// - A tab bar element will be added automatically to the tab bar controller on the IB, you can't delete it
	// - This bar will be displayed automatically on all linked views
	
	
	// UITabBarItem
	// ------------------------------
	// The "tab bar item" element has properties that define the text and icon to display on the tab button representing the linked view
	// - A tab bar item will be added automatically to all linked view controllers on the IB, you can't delete them
	
	// Properties
	// - Title: Sets the text to display on the tab button
	// - Image: Sets the image to use as icon on the tab button
	// - Selected Image: Sets the image to use as icon when the view is currently selected
	// - badgeValue: Enables a badge on the button, pass nil to disable it
	
	
	// Example (setting badges on each tab)
	// ------------------------------
	override func viewDidLoad() {
		super.viewDidLoad()
		guard let views = viewControllers else { return }
		for view in views {
			switch view.tabBarItem.title {
			case "Red":
				view.tabBarItem.badgeValue = "1"
			case "Orange":
				view.tabBarItem.badgeValue = "2"
			case "Yellow":
				view.tabBarItem.badgeValue = "3"
			case "Green":
				view.tabBarItem.badgeValue = "4"
			case "Blue":
				view.tabBarItem.badgeValue = "5"
			case "Purple":
				view.tabBarItem.badgeValue = "6"
			default:
				break
			}
		}
	}
}
