//
//  ViewController.swift
//  ARShots
//
//  Created by Román Martínez on 3/2/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
	
	
	// Add a hoop on the selected plane
	// ------------------------------
	/*
	transform columns:
	3rd: orientation
	4th: position
	*/
	var hoopAdded = false
	@IBAction func screenTapped(_ sender: UITapGestureRecognizer) {
		if !hoopAdded {
			let touchLocation = sender.location(in: sceneView)
			let hitTestResult = sceneView.hitTest(touchLocation, types: [.existingPlaneUsingExtent])
			guard let result = hitTestResult.first,
				let planeAnchor = result.anchor as? ARPlaneAnchor,
				planeAnchor.alignment == .vertical else { return }
			addHoop(result: result)
			hoopAdded = true
		} else {
			createBasketball()
		}
	}
	lazy var hoopNode: SCNNode = {
		let hoopScene = SCNScene(named: "art.scnassets/hoop.scn")!
		return hoopScene.rootNode.childNode(withName: "Hoop", recursively: true)!
	}()
	func addHoop(result: ARHitTestResult) {
		let hoopNode = self.hoopNode
		hoopNode.transform = SCNMatrix4( result.worldTransform )
		hoopNode.eulerAngles.x -= .pi / 2
		// hoopNode.scale = SCNVector3(0.5, 0.5, 0.5)
		// Add physics
		hoopNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: hoopNode, options: [SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.concavePolyhedron]))
		//
		sceneView.scene.rootNode.addChildNode(hoopNode)
	}
	func createBasketball() {
		guard let currentFrame = sceneView.session.currentFrame else { return }
		let ball = SCNNode(geometry: SCNSphere(radius: 0.25))
		let cameraTransform = SCNMatrix4(currentFrame.camera.transform)
		//
		ball.geometry?.firstMaterial?.diffuse.contents = UIColor.orange
		ball.transform = cameraTransform
		// Add physics
		let physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: ball, options:[SCNPhysicsShape.Option.collisionMargin: 0.01]))
		ball.physicsBody = physicsBody
		let power = Float(10.0)
		let force = SCNVector3(-cameraTransform.m31*power, -cameraTransform.m32*power, -cameraTransform.m33*power)
		ball.physicsBody?.applyForce(force, asImpulse: true)
		//
		sceneView.scene.rootNode.addChildNode(ball)
	}
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
		
        // Set the scene to the view
//        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
		configuration.planeDetection = [.vertical, .horizontal]

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
	
	
	// Detect planes
	// ------------------------------
	func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
		guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
		let newNode = createPlane(from: planeAnchor)
		node.addChildNode(newNode)
	}
	func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
		guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
		for childNode in node.childNodes {
			updatePlaneSize(on: childNode, from: planeAnchor)
		}
	}
	func createPlane(from anchor: ARPlaneAnchor) -> SCNNode {
		let node = SCNNode()
		let plane = SCNPlane()
		if anchor.alignment == .vertical {
			plane.firstMaterial?.diffuse.contents = UIColor.yellow
		} else {
			plane.firstMaterial?.diffuse.contents = UIColor.red
		}
		plane.firstMaterial?.isDoubleSided = true
		node.geometry = plane
		node.eulerAngles.x = -.pi / 2
		node.opacity = 0.25
		updatePlaneSize(on: node, from: anchor)
		return node
	}
	func updatePlaneSize(on node: SCNNode, from anchor: ARPlaneAnchor) {
		guard let plane = node.geometry as? SCNPlane else { return }
		plane.width = CGFloat(anchor.extent.x)
		plane.height = CGFloat(anchor.extent.z)
	}
	
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
