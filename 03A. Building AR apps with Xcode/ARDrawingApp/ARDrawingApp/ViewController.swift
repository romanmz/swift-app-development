//
//  ViewController.swift
//  ARDrawingApp
//
//  Created by Román Martínez on 3/17/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, OptionsViewControllerDelegate {
	
	
	// Setup AR scene
	// ------------------------------
	@IBOutlet var sceneView: ARSCNView!
	override func viewDidLoad() {
		super.viewDidLoad()
		sceneView.delegate = self
		sceneView.autoenablesDefaultLighting = true
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		let configuration = ARWorldTrackingConfiguration()
		sceneView.session.run(configuration)
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		sceneView.session.pause()
	}
	
	
	// Get settings from options menu
	// ------------------------------
	var selectedNode: SCNNode?
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard segue.identifier == "ShowOptionsSegue",
			let optionsView = segue.destination as? OptionsViewController else { return }
		optionsView.delegate = self
	}
	func objectSelected(node: SCNNode) {
		dismiss(animated: true, completion: nil)
		selectedNode = node
	}
	
	
}
