//
//  ViewController.swift
//  SceneKit-Primitives
//
//  Created by Román Martínez on 3/1/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
	
	func decimalNumber(_ number: Double) -> Double {
		return round(number*100)/100
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
		
		// Show the world origin
		sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin]
		
		// Add lightning
		sceneView.autoenablesDefaultLighting = true
		
        // Load scene
		loadCampus()
		loadMainBuilding()
		loadSidewalks()
		loadGrass()
		
		let totalWidth = 4.5
		let totalDepth = 2.0
		let treeWidth = 0.4
		let treeSpacing = 0.1
		let padding = 0.05
		
		let startX = decimalNumber( (totalWidth / 2) - (treeWidth / 2) - padding )
		let startZ = decimalNumber( (totalDepth / 2) - (treeWidth / 2) - padding )
		let increment = treeWidth + treeSpacing
		for x in stride(from: -startX, through: +startX, by: increment) {
			for z in stride(from: -startZ, through: +startZ, by: increment) {
				if abs(x) == startX || abs(z) == startZ {
					loadTreeTrunk(x: x, z: z)
				}
			}
		}
    }
	
	func loadCampus() {
		let scene = SCNScene(named: "art.scnassets/campus.scn")!
		sceneView.scene = scene
	}
	func loadMainBuilding() {
		// SCNNode: Parent class for all nodes in SceneKit
		let node = SCNNode()
		node.name = "mainBuilding"
		node.position = SCNVector3(x: -4.5, y: -1, z: -4)
		sceneView.scene.rootNode.childNode(withName: "Campus", recursively: true)?.addChildNode(node)
		
		// SCNGeometry: Parent class for all geometry nodes in SceneKit
		
		// Box
		let box = SCNBox(width: 3, height: 1, length: 1, chamferRadius: 0)
		box.firstMaterial?.diffuse.contents = UIColor.brown
		node.geometry = box
	}
	func loadSidewalks() {
		let node = SCNNode()
		node.position = SCNVector3(0, -0.5, 0)
		sceneView.scene.rootNode.childNode(withName: "mainBuilding", recursively: true)?.addChildNode(node)
		
		// Plane
		let plane = SCNPlane(width: 3.5, height: 1.5)
		plane.firstMaterial?.diffuse.contents = UIColor.gray
		plane.firstMaterial?.isDoubleSided = true
		node.geometry = plane
		node.eulerAngles.x = -Float.pi / 2
	}
	func loadGrass() {
		let node = SCNNode()
		node.position = SCNVector3(0, -0.502, 0)
		sceneView.scene.rootNode.childNode(withName: "mainBuilding", recursively: true)?.addChildNode(node)
		
		//
		let plane = SCNPlane(width: 4.5, height: 2)
		plane.firstMaterial?.diffuse.contents = UIColor.green
		plane.firstMaterial?.isDoubleSided = true
		node.geometry = plane
		node.eulerAngles.x = -Float.pi / 2
	}
	func loadTreeTrunk(x:Double, z:Double) {
		let node = SCNNode()
		node.name = "treeTrunk"
		node.position = SCNVector3(x, -0.25, z)
		sceneView.scene.rootNode.childNode(withName: "mainBuilding", recursively: true)?.addChildNode(node)
		
		// Cylinder
		let cylinder = SCNCylinder(radius: 0.05, height: 0.5)
		cylinder.firstMaterial?.diffuse.contents = UIColor.brown
		node.geometry = cylinder
		
		loadTreeLeafs(in: node)
	}
	func loadTreeLeafs(in parentNode: SCNNode) {
		let node = SCNNode()
		node.position = SCNVector3(0, 0.25, 0)
		parentNode.addChildNode(node)
		
		// Sphere
		let sphere = SCNSphere(radius: 0.2)
		sphere.firstMaterial?.diffuse.contents = UIColor.green
		node.geometry = sphere
	}
	
	
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
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
