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
		setupPlaneDetection(configuration)
		setupImageDetection(configuration)
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
	
	
	// Object tracking
	// ------------------------------
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
	
	
	// Enable plane detection
	// ------------------------------
	func setupPlaneDetection(_ config: ARWorldTrackingConfiguration) {
		config.planeDetection = [.horizontal, .vertical]
	}
	func addPlane(to node: SCNNode, using anchor: ARPlaneAnchor) {
		let planeNode = SCNNode()
		let plane = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
		planeNode.geometry = plane
		planeNode.eulerAngles.x = -.pi / 2
		planeNode.opacity = 0.25
		plane.firstMaterial?.diffuse.contents = anchor.alignment == .vertical ? UIColor.white : UIColor.yellow
		plane.firstMaterial?.isDoubleSided = true
		node.addChildNode(planeNode)
	}
	func updatePlane(on node: SCNNode, using anchor: ARPlaneAnchor) {
		guard let planeNode = node.childNodes.first else { return }
		planeNode.position = SCNVector3(anchor.center.x, 0, anchor.center.z)
		guard let plane = planeNode.geometry as? SCNPlane else { return }
		plane.width = CGFloat(anchor.extent.x)
		plane.height = CGFloat(anchor.extent.z)
	}
	
	
	// Enable image detection
	// ------------------------------
	func setupImageDetection(_ config: ARWorldTrackingConfiguration) {
		let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)!
		config.detectionImages = referenceImages
	}
	func addPlane(to node: SCNNode, using anchor: ARImageAnchor) {
		print("detected image!")
		let detectedImage = anchor.referenceImage
		let planeNode = SCNNode()
		let plane = SCNPlane(width: detectedImage.physicalSize.width, height: detectedImage.physicalSize.height)
		planeNode.geometry = plane
		planeNode.opacity = 0.25
		planeNode.eulerAngles.x -= .pi / 2
		plane.firstMaterial?.diffuse.contents = UIColor.red
		plane.firstMaterial?.isDoubleSided = true
		node.addChildNode(planeNode)
	}
	
	
}
