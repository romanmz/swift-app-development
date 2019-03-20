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
	
	
	// Properties
	// ------------------------------
	
	// User settings
	enum placementMode {
		case freeform, plane, image
	}
	var currentMode: placementMode = .freeform {
		didSet { resetSession() }
	}
	var selectedObject: SCNNode?
	var planesAreVisible: Bool = true {
		didSet { updatePlanesVisibility() }
	}
	
	// Placed elements
	var unanchoredNodes: [SCNNode] = []
	var detectedPlanes: [SCNNode] = []
	var detectedImages: [String:ARImageAnchor] = [:]
	var placedObjects: [SCNNode] = []
	
	// Placed elements: actions
	func removeUnanchoredNodes() {
		for node in unanchoredNodes {
			node.removeFromParentNode()
		}
		unanchoredNodes.removeAll()
	}
	func updatePlanesVisibility() {
		for node in detectedPlanes {
			node.isHidden = !planesAreVisible
		}
	}
	func removeLastPlacedObject() {
		guard let lastNode = placedObjects.last else { return }
		lastNode.removeFromParentNode()
		placedObjects.removeLast()
	}
	
	
	// Manage AR session configuration
	// ------------------------------
	func resetSession(clear: Bool = false) {
		let config = ARWorldTrackingConfiguration()
		config.planeDetection = [.horizontal, .vertical]
		if currentMode == .image && selectedObject != nil {
			config.detectionImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)!
		}
		var options: ARSession.RunOptions = []
		if clear {
			options = [.removeExistingAnchors]
			removeUnanchoredNodes()
			detectedPlanes.removeAll()
			detectedImages.removeAll()
			placedObjects.removeAll()
		}
		sceneView.session.run(config, options: options)
	}
	
	
	// User actions
	// ------------------------------
	
	// Change mode
	@IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
		case 0: currentMode = .freeform
		case 1: currentMode = .plane
		case 2: currentMode = .image
		default: break
		}
	}
	
	// Open options screen
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard segue.identifier == "ShowOptionsSegue",
			let optionsView = segue.destination as? OptionsViewController else { return }
		optionsView.delegate = self
	}
	
	// Change selected object
	func objectSelected(node: SCNNode) {
		selectedObject = node
		dismiss(animated: true, completion: nil)
	}
	
	// Toggle planes visibility
	func planesVisibilityToggled() {
		planesAreVisible = !planesAreVisible
		dismiss(animated: true, completion: nil)
	}
	
	// Undo last object
	func undoLastObject() {
		removeLastPlacedObject()
	}
	
	// Reset entire scene
	func resetScene() {
		resetSession(clear: true)
		dismiss(animated: true, completion: nil)
	}
	
	// Close options screen
	func closeOptions() {
		dismiss(animated: true, completion: nil)
	}
	
	
	// Adding and keeping track of nodes
	// ------------------------------
	func addNodeToRoot(_ node: SCNNode) {
		sceneView.scene.rootNode.addChildNode(node)
		unanchoredNodes.append(node)
	}
	func addNodeToAnchor(_ node: SCNNode, anchor: ARAnchor) {
		guard let anchorNode = sceneView.node(for: anchor) else { return }
		anchorNode.addChildNode(node)
	}
	
	
	// Object detection
	// ------------------------------
	
	// Delegate methods
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
	
	// Helper method for creating planes
	func createPlaneNode(width: CGFloat, height: CGFloat, color: UIColor) -> SCNNode {
		let planeNode = SCNNode()
		let plane = SCNPlane(width: width, height: height)
		planeNode.geometry = plane
		planeNode.isHidden = !planesAreVisible
		planeNode.eulerAngles.x = -.pi / 2
		planeNode.opacity = 0.2
		plane.firstMaterial?.diffuse.contents = color
		plane.firstMaterial?.isDoubleSided = true
		return planeNode
	}
	
	// Plane detection
	func addPlane(to node: SCNNode, using anchor: ARPlaneAnchor) {
		let planeNode = createPlaneNode(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z), color: .yellow)
		addNodeToAnchor(planeNode, anchor: anchor)
		detectedPlanes.append(planeNode)
	}
	func updatePlane(on node: SCNNode, using anchor: ARPlaneAnchor) {
		// pending: checking that we're not updating any extra elements other than the basic plane
		guard let planeNode = node.childNodes.first else { return }
		planeNode.position = SCNVector3(anchor.center.x, 0, anchor.center.z)
		guard let plane = planeNode.geometry as? SCNPlane else { return }
		plane.width = CGFloat(anchor.extent.x)
		plane.height = CGFloat(anchor.extent.z)
	}
	
	// Image detection
	func addPlane(to node: SCNNode, using anchor: ARImageAnchor) {
		let detectedImage = anchor.referenceImage
		let planeNode = createPlaneNode(width: detectedImage.physicalSize.width, height: detectedImage.physicalSize.height, color: .white)
		addNodeToAnchor(planeNode, anchor: anchor)
		// remove old image anchors
		let imageName = detectedImage.name ?? ""
		if let oldAnchor = detectedImages.updateValue(anchor, forKey: imageName) {
			sceneView.session.remove(anchor: oldAnchor)
		}
		// place object immediately
		placeObject(onImageUsing: anchor)
	}
	
	
	// Placing selected object
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
	
	// Mode: freeform
	func placeObject() {
		guard let node = selectedObject?.clone(),
			let cameraPosition = sceneView.session.currentFrame?.camera.transform else { return }
		var moveToFront = matrix_identity_float4x4
		moveToFront.columns.3.z = -0.2
		node.simdTransform = matrix_multiply(cameraPosition, moveToFront)
		addNodeToRoot(node)
		placedObjects.append(node)
	}
	
	// Mode: plane
	func placeObject(onPlaneUsing point: CGPoint) {
		guard let node = selectedObject?.clone(),
			pointMeetsThreshold(point),
			let result = sceneView.hitTest(point, types: [.existingPlaneUsingExtent]).first else { return }
		let transform = result.worldTransform
		node.position = SCNVector3(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
		lastObjectPlacedPoint = point
		addNodeToRoot(node)
		placedObjects.append(node)
	}
	
	// Mode: image
	func placeObject(onImageUsing anchor: ARImageAnchor) {
		guard let node = selectedObject?.clone() else { return }
		node.simdTransform = matrix_identity_float4x4
		addNodeToAnchor(node, anchor: anchor)
		placedObjects.append(node)
	}
	
	
	// User touch
	// ------------------------------
	
	// Start
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		guard let touch = touches.first else { return }
		lastObjectPlacedPoint = nil
		switch currentMode {
		case .freeform: placeObject()
		case .plane: placeObject(onPlaneUsing: touch.location(in: sceneView))
		case .image: break // there's no hit test available for image anchors, so we can only hook into the anchor detection event for now
		}
	}
	
	// Move
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesMoved(touches, with: event)
		guard let touch = touches.first else { return }
		switch currentMode {
		case .freeform: break
		case .plane: placeObject(onPlaneUsing: touch.location(in: sceneView))
		case .image: break
		}
	}
	
	
}
