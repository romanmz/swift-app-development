//
//  ViewController.swift
//  ObjectTracking
//
//  Created by Román Martínez on 3/18/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
	
	
	// Initialize
	// ------------------------------
	@IBOutlet var sceneView: ARSCNView!
	override func viewDidLoad() {
		super.viewDidLoad()
		sceneView.delegate = self
		sceneView.showsStatistics = true
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		let configuration = ARWorldTrackingConfiguration()
		// Setup object tracking
		setupObjectsTracking(configuration)
		//
		sceneView.session.run(configuration)
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		sceneView.session.pause()
	}
	
	
	// Setup object tracking
	// ------------------------------
	// When object tracking is enabled, ARKit will automatically add "anchor" elements wherever the specified type of object is detected
	// it also creates a node element so you can insert 3D objects relative to the detected anchor
	// Use the "renderer" delegate methods to handle the detection events
	func setupObjectsTracking(_ config: ARWorldTrackingConfiguration) {
		setupPlaneDetection(config)
		setupImageDetection(config)
	}
	
	// This method is triggered whenever an object is first detected
	func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
		switch anchor {
		case is ARPlaneAnchor: addPlane(to: node, using: anchor as! ARPlaneAnchor)
		case is ARImageAnchor: addPlane(to: node, using: anchor as! ARImageAnchor)
		default: break
		}
	}
	
	// This method is triggered whenever an existing object is updated (because the object itself moved, or because ARKit improved its position or dimensions)
	func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
		switch anchor {
		case is ARPlaneAnchor: updatePlane(on: node, using: anchor as! ARPlaneAnchor)
		default: break
		}
	}
	
	
	// Plane detection
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
	
	
	// Image detection
	// ------------------------------
	// 1. Go to the Assets Catalog and create a new "AR Resource Group", a new folder named "AR Resources" will be created
	// 2. Add all images that should be detected and tracked by ARKit into this folder
	// 3. You need to specify the real-world size of each image
	func setupImageDetection(_ config: ARWorldTrackingConfiguration) {
		let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)!
		config.detectionImages = referenceImages
	}
	func addPlane(to node: SCNNode, using anchor: ARImageAnchor) {
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
