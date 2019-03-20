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
		sceneView.session.run(self.ARConfig)
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		sceneView.session.pause()
	}
	
	
	// Manage AR session configuration
	// ------------------------------
	var planeNodes: [SCNNode] = []
	var ARConfig: ARWorldTrackingConfiguration {
		let config = ARWorldTrackingConfiguration()
		setupPlaneDetection(config)
		setupImageDetection(config)
		return config
	}
	
	
	// Setting: Placement mode
	// ------------------------------
	enum placementMode {
		case freeform, plane, image
	}
	var currentMode: placementMode = .freeform
	@IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
		case 0: currentMode = .freeform
		case 1: currentMode = .plane
		case 2: currentMode = .image
		default: break
		}
	}
	
	
	// Setting: Selected node
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
	
	
	// Setting: Planes visibility
	// ------------------------------
	var planesAreVisible: Bool = true {
		didSet {
			for node in planeNodes {
				node.isHidden = !planesAreVisible
			}
		}
	}
	func planesVisibilityToggled() {
		dismiss(animated: true, completion: nil)
		planesAreVisible = !planesAreVisible
	}
	
	
	// Object tracking
	// ------------------------------
	
	// General methods
	func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
		switch anchor {
		case is ARPlaneAnchor: addPlane(to: node, using: anchor as! ARPlaneAnchor)
		case is ARImageAnchor: addPlane(to: node, using: anchor as! ARImageAnchor)
		default: break
		}
	}
	func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
		switch anchor {
		case is ARPlaneAnchor: updatePlane(on: node, using: anchor as! ARPlaneAnchor)
		default: break
		}
	}
	func createPlaneNode(width: CGFloat, height: CGFloat, color: UIColor) -> SCNNode {
		let planeNode = SCNNode()
		let plane = SCNPlane(width: width, height: height)
		planeNode.geometry = plane
		planeNode.isHidden = !planesAreVisible
		planeNode.eulerAngles.x = -.pi / 2
		planeNode.opacity = 0.25
		plane.firstMaterial?.diffuse.contents = color
		plane.firstMaterial?.isDoubleSided = true
		planeNodes.append(planeNode)
		return planeNode
	}
	
	// Plane detection
	func setupPlaneDetection(_ config: ARWorldTrackingConfiguration) {
		config.planeDetection = [.horizontal, .vertical]
	}
	func addPlane(to node: SCNNode, using anchor: ARPlaneAnchor) {
		let width = CGFloat(anchor.extent.x)
		let height = CGFloat(anchor.extent.z)
		let color = anchor.alignment == .vertical ? UIColor.white : UIColor.yellow
		let planeNode = createPlaneNode(width: width, height: height, color: color)
		node.addChildNode(planeNode)
	}
	func updatePlane(on node: SCNNode, using anchor: ARPlaneAnchor) {
		guard let planeNode = node.childNodes.first else { return }
		planeNode.position = SCNVector3(anchor.center.x, 0, anchor.center.z)
		guard let plane = planeNode.geometry as? SCNPlane else { return }
		plane.width = CGFloat(anchor.extent.x)
		plane.height = CGFloat(anchor.extent.z)
	}
	
	// Image detection
	func setupImageDetection(_ config: ARWorldTrackingConfiguration) {
		let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)!
		config.detectionImages = referenceImages
	}
	func addPlane(to node: SCNNode, using anchor: ARImageAnchor) {
		let detectedImage = anchor.referenceImage
		let width = detectedImage.physicalSize.width
		let height = detectedImage.physicalSize.height
		let color = UIColor.red
		let planeNode = createPlaneNode(width: width, height: height, color: color)
		node.addChildNode(planeNode)
	}
	
	
}
