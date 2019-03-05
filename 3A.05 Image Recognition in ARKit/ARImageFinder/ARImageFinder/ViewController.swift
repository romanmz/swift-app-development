//
//  ViewController.swift
//  ARImageFinder
//
//  Created by Román Martínez on 3/4/19.
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

		// Detect images in AR
		let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)!
		configuration.detectionImages = referenceImages
		
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
	
	
	// Detect Images in AR
	func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
		guard let imageAnchor = anchor as? ARImageAnchor else { return }
		print("image discovered: \(imageAnchor.name!)")
		// Add plane on top of image
		let detectedImage = imageAnchor.referenceImage
		let plane = SCNPlane(width: detectedImage.physicalSize.width, height: detectedImage.physicalSize.height)
		let newNode = SCNNode(geometry: plane)
		plane.firstMaterial?.diffuse.contents = UIColor.blue
		newNode.opacity = 0.25
		newNode.eulerAngles.x -= .pi / 2
		node.addChildNode(newNode)
		//
		newNode.runAction(waitRemoveAction)
	}
	var waitRemoveAction: SCNAction {
		return .sequence([.wait(duration: 5), .fadeOut(duration: 2), .removeFromParentNode()])
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
