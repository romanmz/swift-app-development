//
//  ViewController.swift
//  SceneKitBasics
//
//  Created by Román Martínez on 3/17/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
	
	
	// Initialize
	// ------------------------------
	override func viewDidLoad() {
		super.viewDidLoad()
		setupScene()
		load3dObjectFromFile()
		build3dObject()
	}
	
	
	// Setup scene
	// ------------------------------
	@IBOutlet var sceneView: ARSCNView!
	func setupScene() {
		sceneView.delegate = self
		sceneView.showsStatistics = true
		sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin]
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
	
	
	// Load 3D object from file
	// ------------------------------
	func load3dObjectFromFile() {
		let scene = SCNScene(named: "art.scnassets/campus.scn")!
		sceneView.scene = scene
	}
	
	
	// Build 3D object programmatically
	// ------------------------------
	// SCNNode: Parent class for all nodes in SceneKit
	// SCNGeometry: Parent class for all geometry nodes in SceneKit
	func build3dObject() {
		
		// Get the parent node of the scene loaded from file
		guard let campusNode = sceneView.scene.rootNode.childNode(withName: "Campus", recursively: true) else { return }
		
		// Get elements created programmatically
		let buildingNode = getMainBuilding()
		let sidewalkNode = getSidewalk()
		let grassNode = getGrass()
		
		// Add to scene
		campusNode.addChildNode(buildingNode)
		buildingNode.addChildNode(sidewalkNode)
		buildingNode.addChildNode(grassNode)
		
		let totalWidth = 4.5
		let totalDepth = 2.0
		let treeWidth = 0.4
		let treeSpacing = 0.1
		let padding = 0.05
		
		let startX = ( (totalWidth / 2) - (treeWidth / 2) - padding ).decimal
		let startZ = ( (totalDepth / 2) - (treeWidth / 2) - padding ).decimal
		let increment = treeWidth + treeSpacing
		for x in stride(from: -startX, through: +startX, by: increment) {
			for z in stride(from: -startZ, through: +startZ, by: increment) {
				if abs(x) == startX || abs(z) == startZ {
					let tree = getTreeTrunk(x: x, z: z)
					buildingNode.addChildNode(tree)
				}
			}
		}
	}
	
	
	// SCNBox geometry
	// ------------------------------
	func getMainBuilding() -> SCNNode {
		let node = SCNNode()
		node.position = SCNVector3(x: -2.25, y: -1, z: -4)
		let box = SCNBox(width: 3, height: 1, length: 1, chamferRadius: 0)
		box.firstMaterial?.diffuse.contents = UIColor.brown
		node.geometry = box
		return node
	}
	
	
	// SCNPlane geometry
	// ------------------------------
	func getSidewalk() -> SCNNode {
		let node = SCNNode()
		node.position = SCNVector3(0, -0.5, 0)
		node.eulerAngles.x = -Float.pi / 2
		let plane = SCNPlane(width: 3.5, height: 1.5)
		plane.firstMaterial?.diffuse.contents = UIColor.gray
		plane.firstMaterial?.isDoubleSided = true
		node.geometry = plane
		return node
	}
	func getGrass() -> SCNNode {
		let node = SCNNode()
		node.position = SCNVector3(0, -0.502, 0)
		node.eulerAngles.x = -Float.pi / 2
		let plane = SCNPlane(width: 4.5, height: 2)
		plane.firstMaterial?.diffuse.contents = UIColor.green
		plane.firstMaterial?.isDoubleSided = true
		node.geometry = plane
		return node
	}
	
	
	// SCNCylinder geometry
	// ------------------------------
	func getTreeTrunk(x:Double, z:Double) -> SCNNode {
		let node = SCNNode()
		node.position = SCNVector3(x, -0.25, z)
		let cylinder = SCNCylinder(radius: 0.05, height: 0.5)
		cylinder.firstMaterial?.diffuse.contents = UIColor.brown
		node.geometry = cylinder
		// load leafs
		let treeLeafs = getTreeLeafs()
		node.addChildNode(treeLeafs)
		// return
		return node
	}
	
	
	// SCNSphere geometry
	// ------------------------------
	func getTreeLeafs() -> SCNNode {
		let node = SCNNode()
		node.position = SCNVector3(0, 0.25, 0)
		let sphere = SCNSphere(radius: 0.2)
		sphere.firstMaterial?.diffuse.contents = UIColor.green
		node.geometry = sphere
		return node
	}
}
