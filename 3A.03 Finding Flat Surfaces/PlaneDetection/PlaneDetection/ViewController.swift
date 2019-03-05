//
//  ViewController.swift
//  PlaneDetection
//
//  Created by Román Martínez on 3/1/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        // let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        // sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
		
		// Automatically adds "anchors" and nodes whenever horizontal planes are detected
		// Use the "renderer" delegate methods to handle the detection events
		configuration.planeDetection = [.horizontal]

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
	func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
		// check that the new anchor is a horizontal plane
		guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
		let planeNode = getPlaneFrom(anchor: planeAnchor)
		node.addChildNode(planeNode)
		let shipNode = createShipFrom(anchor: planeAnchor)
		node.addChildNode(shipNode)
	}
	func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
		guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
		for childNode in node.childNodes {
			update(node: childNode, fromAnchor: planeAnchor)
		}
	}
	
	// Place objects
	func getPlaneFrom(anchor: ARPlaneAnchor) -> SCNNode {
		let node = SCNNode()
		let plane = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
		node.geometry = plane
		node.eulerAngles.x = -.pi / 2
		node.opacity = 0.25
		return node
	}
	func update(node: SCNNode, fromAnchor anchor: ARPlaneAnchor) {
		node.position = SCNVector3(anchor.center.x, 0, anchor.center.z)
		if let plane = node.geometry as? SCNPlane {
			plane.width = CGFloat(anchor.extent.x)
			plane.height = CGFloat(anchor.extent.z)
		}
	}
	func createShipFrom(anchor: ARPlaneAnchor) -> SCNNode {
		let node = SCNScene(named: "art.scnassets/ship.scn")!.rootNode.clone()
		node.position = SCNVector3(anchor.center.x, 0, anchor.center.z)
		return node
	}
	
    
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
