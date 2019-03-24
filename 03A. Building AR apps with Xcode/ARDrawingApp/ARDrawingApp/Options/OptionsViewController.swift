//
//  OptionsViewController.swift
//  ARDrawingApp
//
//  Created by Román Martínez on 3/19/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit
import SceneKit


// Delegate
// ------------------------------
protocol OptionsViewControllerDelegate: class {
	func objectSelected(node: SCNNode)
	func planesVisibilityToggled()
	func undoLastObject()
	func resetScene()
	func closeOptions()
}


class OptionsViewController: UIViewController {
	
	
	// Properties
	// ------------------------------
	
	// Object settings
	var selectedShape: Shape = .box
	var selectedSize: Size = .medium
	var selectedColor: Color = .red
	var selectedNode: SCNNode {
		let geometry = selectedShape.createGeometry(size: selectedSize.value)
		geometry.firstMaterial?.diffuse.contents = selectedColor.value
		return SCNNode(geometry: geometry)
	}
	
	// Delegate
	weak var delegate: OptionsViewControllerDelegate?
	
	
	// Initialize
	// ------------------------------
	override func viewDidLoad() {
		super.viewDidLoad()
		setupNavController()
	}
	
	
	// Setup nav controller
	// ------------------------------
	private var navController: UINavigationController!
	private func setupNavController() {
		navController = UINavigationController(rootViewController: optionPicker)
		navController.topViewController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(closeOptions))
		
		// Prepare root view
		let newView = navController.view!
		newView.translatesAutoresizingMaskIntoConstraints = true
		newView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		newView.frame = view.bounds
		view.addSubview(newView)
		
		// Transition
		addChild(navController)
		UIView.animate(withDuration: 0.3, delay: 0, options: [.transitionCrossDissolve], animations: {}) {
			done in
			self.navController.didMove(toParent: self)
		}
	}
	@objc private func closeOptions() {
		delegate?.closeOptions()
	}
	
	
	// Dynamic view controllers
	// ------------------------------
	
	// Option picker
	private var optionPicker: UIViewController {
		return OptionSelectorViewController(options: [
			Option(title: "Select Basic Shape", callback: { self.navController.pushViewController(self.shapePicker, animated: true) }, showIndicator: true),
			Option(title: "Select Scene File", callback: { self.navController.pushViewController(self.scenePicker, animated: true) }, showIndicator: true),
			Option(title: "Toggle Planes Visibility", callback: { self.delegate?.planesVisibilityToggled() }),
			Option(title: "Undo Last Shape", callback: { self.delegate?.undoLastObject() }),
			Option(title: "Reset Scene", callback: { self.delegate?.resetScene() }),
		])
	}
	
	// Shape picker
	private var shapePicker: UIViewController {
		let options = Shape.allCases.map { shape in
			return Option(title: shape.rawValue, callback: {
				self.selectedShape = shape
				self.navController.pushViewController(self.sizePicker, animated: true)
			}, showIndicator: true)
		}
		return OptionSelectorViewController(options: options)
	}
	
	// Size picker
	private var sizePicker: UIViewController {
		let options = Size.allCases.map { size in
			return Option(title: size.rawValue, callback: {
				self.selectedSize = size
				self.navController.pushViewController(self.colorPicker, animated: true)
			}, showIndicator: true)
		}
		return OptionSelectorViewController(options: options)
	}
	
	// Color picker
	private var colorPicker: UIViewController {
		let options = Color.allCases.map { color in
			return Option(title: color.rawValue, callback: {
				self.selectedColor = color
				self.delegate?.objectSelected(node: self.selectedNode)
			})
		}
		return OptionSelectorViewController(options: options)
	}
	
	// Scene file picker
	private var scenePicker: UIViewController {
		
		// Get all .scn files
		let modelsFolder = "models.scnassets"
		let scnFiles: [String] = {
			let folderURL = Bundle.main.url(forResource: modelsFolder, withExtension: nil)!
			let fileEnumerator = FileManager().enumerator(at: folderURL, includingPropertiesForKeys: [])!
			return fileEnumerator.compactMap { fileItem in
				guard let url = fileItem as? URL,
					url.pathExtension == "scn" else { return nil }
				return url.lastPathComponent
			}
		}()
		
		// Build options
		let options: [Option] = scnFiles.compactMap { scnFile in
			let scnFolder = scnFile.replacingOccurrences(of: ".scn", with: "")
			let fullPath = "\(modelsFolder)/\(scnFolder)/\(scnFile)"
			guard let scene = SCNScene(named: fullPath) else { return nil }
			return Option(title: scnFile, callback: {
				self.delegate?.objectSelected(node: scene.rootNode)
			})
		}
		return OptionSelectorViewController(options: options)
	}
}
