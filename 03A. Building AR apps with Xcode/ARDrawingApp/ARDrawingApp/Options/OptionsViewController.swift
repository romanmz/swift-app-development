//
//  OptionsViewController.swift
//  ARDrawingApp
//
//  Created by Román Martínez on 3/19/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {
	
	
	// Initialize
	// ------------------------------
	override func viewDidLoad() {
		super.viewDidLoad()
		setupNavController()
	}
	
	
	// Setup nav controller
	// ------------------------------
	private var nav: UINavigationController?
	private func setupNavController() {
		let navController = UINavigationController(rootViewController: optionPicker)
		nav = navController
		transition(to: navController)
	}
	
	
	// Option picker
	// ------------------------------
	private var optionPicker: UIViewController {
		return OptionSelectorViewController(options: MenuOption.all, onSelect: optionSelected)
	}
	private func optionSelected(_ option: MenuOption) {
		switch option {
		case .addShape:
		case .addScene:
		case .togglePlanes:
		case .undo:
		case .reset:
		}
	}
	
	
	// Transition between views
	// ------------------------------
	func transition(to viewController: UIViewController, completion: ((Bool) -> Void)? = nil) {
		
		// Check if this is the first view controller
		guard let currentController = children.last else {
			presentFirst(viewController: viewController, completion: completion)
			return
		}
		
	}
	func presentFirst(viewController: UIViewController, completion: ((Bool) -> Void)? = nil) {
		
		// Prepare root view
		let newView = viewController.view!
		newView.translatesAutoresizingMaskIntoConstraints = true
		newView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		newView.frame = view.bounds
		view?.addSubview(newView)
		
		// Transition
		addChild(viewController)
		UIView.animate(withDuration: 0.3, delay: 0, options: [.transitionCrossDissolve], animations: {}) {
			done in
			viewController.didMove(toParent: self)
			completion?(done)
		}
	}
	
	
}
