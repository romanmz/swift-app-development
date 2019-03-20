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
		resetSession()
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		sceneView.session.pause()
	}
	
	
	// Manage AR session configuration
	// ------------------------------
	var planeNodes: [SCNNode] = []
	var imageAnchors: [String:ARImageAnchor] = [:]
	func clearImageAnchors() {
		for (_, anchor) in imageAnchors {
			sceneView.session.remove(anchor: anchor)
		}
		imageAnchors.removeAll()
	}
	var placedNodes: [SCNNode] = []
	func resetSession() {
		let config = ARWorldTrackingConfiguration()
		setupPlaneDetection(config)
		if currentMode == .image && selectedNode != nil {
			setupImageDetection(config)
		}
		let options: ARSession.RunOptions = []//[.resetTracking, .removeExistingAnchors]
		sceneView.session.run(config, options: options)
	}
	
	
	// Setting: Placement mode
	// ------------------------------
	enum placementMode {
		case freeform, plane, image
	}
	var currentMode: placementMode = .freeform {
		didSet {
			resetSession()
		}
	}
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
		planeNodes.append(planeNode)
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
		let imageName = detectedImage.name ?? ""
		let width = detectedImage.physicalSize.width
		let height = detectedImage.physicalSize.height
		let color = UIColor.red
		let planeNode = createPlaneNode(width: width, height: height, color: color)
		node.addChildNode(planeNode)
		if let oldAnchor = imageAnchors.updateValue(anchor, forKey: imageName) {
			sceneView.session.remove(anchor: oldAnchor)
		}
		// add currently selected node
		guard let selectedNode = selectedNode else { return }
		selectedNode.simdTransform = matrix_identity_float4x4
		addNodeToParent(selectedNode, parent: node)
	}
	
	
	// Place nodes
	// ------------------------------
	
	// Distance threshold (for plane mode only)
	var lastObjectPlacedPoint: CGPoint?
	let touchDistanceThreshold: CGFloat = 20.0
	func distanceBetween(_ point1: CGPoint, _ point2: CGPoint) -> CGFloat {
		let a = pow((point1.x - point2.x), 2.0)
		let b = pow((point1.y - point2.y), 2.0)
		return sqrt(a + b)
	}
	func pointMeetsThreshold(_ point: CGPoint) -> Bool {
		guard let lastPoint = lastObjectPlacedPoint else { return true }
		return distanceBetween(point, lastPoint) >= touchDistanceThreshold
	}
	
	// Add nodes to the scene
	func addNodeToScene(_ node: SCNNode) {
		let newNode = node.clone()
		sceneView.scene.rootNode.addChildNode(newNode)
		placedNodes.append(newNode)
	}
	func addNodeToParent(_ node: SCNNode, parent: SCNNode) {
		let newNode = node.clone()
		parent.addChildNode(newNode)
		placedNodes.append(newNode)
	}
	
	// Mode: freeform
	func placeNodeInFront(_ node: SCNNode) {
		guard let cameraPosition = sceneView.session.currentFrame?.camera.transform else { return }
		var moveToFront = matrix_identity_float4x4
		moveToFront.columns.3.z = -0.2
		node.simdTransform = matrix_multiply(cameraPosition, moveToFront)
		addNodeToScene(node)
	}
	
	// Mode: plane
	func placeNode(_ node: SCNNode, onPlaneUsing point: CGPoint) {
		guard pointMeetsThreshold(point),
			let result = sceneView.hitTest(point, types: [.existingPlaneUsingExtent]).first else { return }
		let transform = result.worldTransform
		node.position = SCNVector3(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
		lastObjectPlacedPoint = point
		addNodeToScene(node)
	}
	
	
	// Detect touch
	// ------------------------------
	
	// Start
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		guard let node = selectedNode,
			let touch = touches.first else { return }
		lastObjectPlacedPoint = nil
		let touchPoint = touch.location(in: sceneView)
		switch currentMode {
		case .freeform: placeNodeInFront(node)
		case .plane: placeNode(node, onPlaneUsing: touchPoint)
		case .image: break // there's no hit test available for image anchors, so we can only hook into the anchor detection event for now
		}
	}
	
	// Move
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesMoved(touches, with: event)
		guard let node = selectedNode,
			let touch = touches.first else { return }
		let touchPoint = touch.location(in: sceneView)
		switch currentMode {
		case .freeform: break
		case .plane: placeNode(node, onPlaneUsing: touchPoint)
		case .image: break
		}
	}
	
	
}
