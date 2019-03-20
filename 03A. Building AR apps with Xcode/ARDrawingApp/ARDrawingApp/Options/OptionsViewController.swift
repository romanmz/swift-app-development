//
//  OptionsViewController.swift
//  ARDrawingApp
//
//  Created by Román Martínez on 3/19/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {
	
	
	// Properties
	// ------------------------------
	var selectedShape: Shape?
	var selectedSize: Size?
	
	
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
		return OptionSelectorViewController(options: [
			Option(title: "Select Basic Shape", callback: { self.nav?.pushViewController(self.shapePicker, animated: true) }, showIndicator: true),
			Option(title: "Select Scene File", callback: {}, showIndicator: true),
			Option(title: "Toggle Planes Visibility", callback: {}),
			Option(title: "Undo Last Shape", callback: {}),
			Option(title: "Reset Scene", callback: {}),
		])
	}
	
	
	// Shape picker
	// ------------------------------
	private var shapePicker: UIViewController {
		let options = Shape.all.map { shape in
			return Option(title: shape.rawValue, callback: {
				self.selectedShape = shape
				self.nav?.pushViewController(self.sizePicker, animated: true)
			}, showIndicator: true)
		}
		return OptionSelectorViewController(options: options)
	}
	
	
	// Size picker
	// ------------------------------
	private var sizePicker: UIViewController {
		let options = Size.all.map { size in
			return Option(title: size.rawValue, callback: {
				self.selectedSize = size
			}, showIndicator: true)
		}
		return OptionSelectorViewController(options: options)
	}
	
	
	// Transition between views
	// ------------------------------
	private func transition(to viewController: UIViewController, completion: ((Bool) -> Void)? = nil) {
		
		// Check if this is the first view controller
		guard let currentController = children.last else {
			presentFirst(viewController: viewController, completion: completion)
			return
		}
		
		// Transition between views
		addChild(viewController)
		currentController.willMove(toParent: nil)
		transition(from: currentController, to: viewController, duration: 0.3, options: [.transitionCrossDissolve], animations: {}) {
			done in
			currentController.removeFromParent()
			viewController.didMove(toParent: self)
			completion?(done)
		}
	}
	private func presentFirst(viewController: UIViewController, completion: ((Bool) -> Void)? = nil) {
		
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
