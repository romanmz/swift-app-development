//
//  ViewController.swift
//  ARDynamicsBasics
//
//  Created by Román Martínez on 3/18/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
	
	
	// Prepare: AR
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
		configuration.planeDetection = [.vertical]
		sceneView.session.run(configuration)
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		sceneView.session.pause()
	}
	
	
	// Prepare: Plane detection
	// ------------------------------
	func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
		guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
		let planeNode = SCNNode()
		let plane = SCNPlane()
		planeNode.name = "detected_plane"
		planeNode.geometry = plane
		planeNode.eulerAngles.x = -.pi / 2
		planeNode.opacity = 0.25
		plane.firstMaterial?.diffuse.contents = UIColor.white
		plane.firstMaterial?.isDoubleSided = true
		updatePlane(on: planeNode, with: planeAnchor)
		node.addChildNode(planeNode)
	}
	func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
		guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
		for childNode in node.childNodes {
			updatePlane(on: childNode, with: planeAnchor)
		}
	}
	func updatePlane(on node: SCNNode, with anchor: ARPlaneAnchor) {
		guard let plane = node.geometry as? SCNPlane,
			node.name == "detected_plane" else { return }
		plane.width = CGFloat(anchor.extent.x)
		plane.height = CGFloat(anchor.extent.z)
	}
	
	
	// Prepare: Nodes for testing
	// ------------------------------
	var hoopNode: SCNNode {
		let scene = SCNScene(named: "art.scnassets/hoop.scn")!
		let node = scene.rootNode.childNode(withName: "Hoop", recursively: true)!
		node.eulerAngles.x -= .pi / 2
		addStaticPhysics(to: node)
		return node
	}
	var basketballNode: SCNNode {
		let node = SCNNode()
		let sphere = SCNSphere(radius: 0.25)
		node.geometry = sphere
		sphere.firstMaterial?.diffuse.contents = UIColor.orange
		addDynamicPhysics(to: node)
		return node
	}
	
	
	// Position elements relative to camera
	// ------------------------------
	// Use the "currentFrame" property of the running ARSession element to get general information about the current status of the AR simulation
	// The frame property has a "camera" property where you can get info about the current position of the camera (the user device in this case)
	func placeAtCameraPosition(node: SCNNode) {
		guard let currentFrame = sceneView.session.currentFrame else { return }
		node.transform = SCNMatrix4(currentFrame.camera.transform)
	}
	
	
	// SceneKit Physics
	// ------------------------------
	// SCNPhysicsShape
	// Most of the times (but not always) you'll want to have the physics body of a node to match the shape of the node itself,
	// so when you create a SCNPhysicsShape you have the option to pass a node to the initializer to copy the existing geometry and apply extra settings:
	// type:
	// - boundingBox: simple containing box, lowest detail but fastest performance
	// - convexHull: moderately detailed geometry, medium detail
	// - concavePolyhedron: highly detailed geometry, more precise simulation but lowest performance
	// collisionMargin: expands the limits of the geometry used for collision detection
	
	// SCNPhysicsBody
	// Can be defined as one of three possible types:
	// - static: for elements that are meant to remain fixed and not affected by any physics, but other elements still can be affected by them, e.g. a wall
	// - kinematic: for elements that are not affected by any physics, but that can move and affect other elements, e.g. sliding doors
	// - dynamic: for elements that can be affected by physics and collisions with other elements
	func addStaticPhysics(to node: SCNNode) {
		let physicsShape = SCNPhysicsShape(node: node, options: [SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.concavePolyhedron])
		let physicsBody = SCNPhysicsBody(type: .static, shape: physicsShape)
		node.physicsBody = physicsBody
	}
	func addDynamicPhysics(to node: SCNNode) {
		let physicsShape = SCNPhysicsShape(node: node, options:[SCNPhysicsShape.Option.collisionMargin: 0.01])
		let physicsBody = SCNPhysicsBody(type: .dynamic, shape: physicsShape)
		node.physicsBody = physicsBody
	}
	
	// Applying forces
	// Use the applyForce() method on a physics body to propel the node towards a particular direction
	func pushForward(node: SCNNode) {
		let transform = node.transform
		let power = Float(10.0)
		let force = SCNVector3(-transform.m31*power, -transform.m32*power, -transform.m33*power)
		node.physicsBody?.applyForce(force, asImpulse: true)
	}
	
	
	// Detecting matching element(s) at a given position
	// ------------------------------
	// Use the hitTest() method on the ARSCNView element to check if a given point intersects an existing point or plane on the AR session
	// the returned result is an array containing all matching elements, with the closest ones listed first
	// each result has an "anchor" property where you can access the matching ARAnchor element
	// Use the node(for:) method on the ARSCNView element to get the node that corresponds to the found anchor
	func getClosestPlaneNode(at point: CGPoint) -> SCNNode? {
		let hitResults = sceneView.hitTest(point, types: [.existingPlaneUsingExtent])
		guard let hitResult = hitResults.first,
			let planeAnchor = hitResult.anchor as? ARPlaneAnchor,
			planeAnchor.alignment == .vertical,
			let tappedNode = sceneView.node(for: planeAnchor) else { return nil }
		return tappedNode
	}
	
	
	// Putting everything together
	// ------------------------------
	var hoopAdded = false
	@IBAction func screenWasTapped(_ sender: UITapGestureRecognizer) {
		if !hoopAdded {
			let touchPosition = sender.location(in: sceneView)
			guard let tappedNode = getClosestPlaneNode(at: touchPosition) else { return }
			tappedNode.addChildNode(hoopNode)
			hoopAdded = true
		} else {
			let ball = basketballNode
			placeAtCameraPosition(node: ball)
			pushForward(node: ball)
			sceneView.scene.rootNode.addChildNode(ball)
		}
	}
	
	
	
}
