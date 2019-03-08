//
//  ViewController.swift
//  UIKitBasics
//
//  Created by Román Martínez on 3/4/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		// ++++++++++++++++++++++++++++++
		programmaticEvents()
		keyboardDetection()
		enableScrollViewZooming()
	}
	
	
	// Basic UI elements
	// ------------------------------
	// UILabel
	// UIImageView
	// UITextView
	
	
	// Input controls
	// ------------------------------
	@IBAction func buttonPressed(_ sender: UIButton) {
		print("The button was tapped!")
	}
	@IBAction func switchToggled(_ sender: UISwitch) {
		print("The switch is now \(sender.isOn ? "on" : "off")!")
	}
	@IBAction func sliderMoved(_ sender: UISlider) {
		print("The slider value is \(sender.value)!")
	}
	@IBAction func textChanged(_ sender: UITextField) {
		var text = sender.text ?? "(empty)"
		if text.isEmpty { text = "(empty)" }
		print("The text is now \(text)!")
	}
	
	
	// Bind callbacks to input control events programmatically
	// ------------------------------
	// Use .addTarget() to bind callback functions to events triggered by input elements
	// the callback function needs to be marked as @objc
	@IBOutlet weak var button: UIButton!
	func programmaticEvents() {
		button.addTarget(self, action: #selector(buttonAlsoPressed), for: .touchUpInside)
	}
	@objc func buttonAlsoPressed() {
		print("This action was added programmatically!")
	}
	
	
	// Gesture recognizers
	// ------------------------------
	// Use the "Gesture Recognizer" elements to detect specific gestures done by the user (tap, double tap, swipe, etc…)
	// they are shortcuts so you don't have to manually track down the touch movements using the touchesBegan, touchesMoved, etc… methods
	@IBAction func onSingleTap(_ sender: UITapGestureRecognizer) {
		let location = sender.location(in: view)
		print("Single tap gesture on: \(location)")
	}
	
	
	// Keyboard Detection
	// ------------------------------
	// Observe the ".UIResponder.keyboardDidShowNotification" and ".UIResponder.keyboardWillHideNotification" notifications
	// to make changes to your views whenever the keyboard appears/disappears
	func keyboardDetection() {
		NotificationCenter.default.addObserver(self, selector: #selector( keyboardWasShown(_:) ), name: UIResponder.keyboardDidShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector( keyboardWillBeHidden(_:) ), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	
	// Scroll View
	// ------------------------------
	// To get the stupid UIScrollView element to work properly:
	// 1. Add it as a child of UIView and align it to all 4 edges
	// 2. Add a child UIView (optionally named "Content View") inside UIScrollView, align all 4 edges
	// 3. To prevent horizontal scrolling add a width constraint so that the content view always matches the scroll view (or a height constraint to prevent vertical scrolling)
	// 4. All elements within the content view should have constraints to make it so that the content view has defined constraints edge to edge, both horizontally and vertically
	
	// You can dynamically edit the visible content area, and the scroll indicators by editing the "contentInset" and "scrollIndicatorInsets" properties
	// Example, adjusting the box when the keyboard appears/disappears:
	@IBOutlet weak var scrollBox: UIScrollView!
	@objc func keyboardWasShown(_ notificiation: NSNotification) {
		guard let info = notificiation.userInfo,
			let keyboardFrameValue = info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else { return }
		let keyboardFrame = keyboardFrameValue.cgRectValue
		let keyboardSize = keyboardFrame.size
		let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
		scrollBox.contentInset = contentInsets
		scrollBox.scrollIndicatorInsets = contentInsets
	}
	@objc func keyboardWillBeHidden(_ notification: NSNotification) {
		let contentInsets = UIEdgeInsets.zero
		scrollBox.contentInset = contentInsets
		scrollBox.scrollIndicatorInsets = contentInsets
	}
	
	
	// Zooming in/out
	// By default a UIScrollView element doesn't allow users to zoom in or out on the content, but you have the option to enable it:
	// 1. Create an class that conforms to the UIScrollViewDelegate protocol, and assign it to the "delegate" property of the scroll view
	// 2. Call the delegate method "viewForZooming" and return the element within the scroll view that will have the zoom applied to
	// 3. Change the value of the property minimumZoomScale and/or maximumZoomScale, as both equal 1.0 by default
	@IBOutlet weak var scrollContentBox: UIView!
	func enableScrollViewZooming() {
		scrollBox.delegate = self
		scrollBox.minimumZoomScale = 0.5
		scrollBox.maximumZoomScale = 2.0
	}
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return scrollContentBox
	}
	
	
	// Constraints and Stack Views
	// ------------------------------
	// Use Constraints/AutoLayout to determine how elements should be placed relative to the screen and to each other
	// The UIStackView element lets you group items and more easily apply alignment and distribution rules to them
	
	
}
