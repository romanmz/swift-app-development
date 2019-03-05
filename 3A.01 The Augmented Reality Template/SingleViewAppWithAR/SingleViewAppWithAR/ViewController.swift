//
//  ViewController.swift
//  SingleViewAppWithAR
//
//  Created by Román Martínez on 3/1/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit
import SceneKit
import ARKit


class ViewController: UIViewController, ARSCNViewDelegate {

	@IBOutlet weak var sceneView: ARSCNView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		sceneView.delegate = self
		sceneView.showsStatistics = true
		sceneView.debugOptions = ARSCNDebugOptions.showWorldOrigin
		
		// Set the scene to the view
		let scene = SCNScene(named: "TestScene.scn")!
		sceneView.scene = scene
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
}
