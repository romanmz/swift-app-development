//
//  ViewController.swift
//  ARKitBasics
//
//  Created by Román Martínez on 3/17/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
	
	
	// Info.plist settings
	// ------------------------------
	// These settings are required for an AR app (they are included automatically on "Augmented Reality App" templates
	// NSCameraUsageDescription: To request access to the device camera
	// UIRequiredDeviceCapabilities > arkit: To limit to devices that can actually run AR
	// UIStatusBarHidden: Hide the status bar (optional)
	
	
	// SCN Assets folder
	// ------------------------------
	// To include .scn files into your application, it's better to use assets folders with a .scnassets extension instead of the default .xcassets
	// to create one go to File > New > File, pick the "Asset Catalog" option, and when naming it make sure you add the .scnassets extension
	
	
	// Setup AR Scene
	// ------------------------------
	// Most of these settings are created automatically if you create a project using the "Augmented Reality App" template
	@IBOutlet var sceneView: ARSCNView!
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Set the view's delegate
		sceneView.delegate = self
		
		// Debugging settings
		sceneView.showsStatistics = true
		sceneView.debugOptions = [
			ARSCNDebugOptions.showWorldOrigin,
			ARSCNDebugOptions.showFeaturePoints,
			ARSCNDebugOptions.renderAsWireframe,
			ARSCNDebugOptions.showBoundingBoxes,
		]
		
		// Load a 3D scene from file
		let scene = SCNScene(named: "art.scnassets/ship.scn")!
		sceneView.scene = scene
	}
	
	
	// Begin and stop AR sessions
	// ------------------------------
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		let configuration = ARWorldTrackingConfiguration()
		sceneView.session.run(configuration)
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		sceneView.session.pause()
	}
	
	
	// Adding nodes to the scene when an "anchor" element is detected (planes, images, objects and faces)
	// ------------------------------
	func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
		let node = SCNNode()
		return node
	}
	
	
	// AR session hooks
	// ------------------------------
	func session(_ session: ARSession, didFailWithError error: Error) {
		// Present an error message to the user
	}
	func sessionWasInterrupted(_ session: ARSession) {
		// Inform the user that the session has been interrupted, for example, by presenting an overlay
	}
	func sessionInterruptionEnded(_ session: ARSession) {
		// Reset tracking and/or remove existing anchors if consistent tracking is required
	}
	
	
}
