import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
	var selectedNode: SCNNode?
    
    enum ObjectPlacementMode {
        case freeform, plane, image
    }
    
	var objectMode: ObjectPlacementMode = .freeform {
		didSet {
			reloadConfiguration(removeAnchors: false)
		}
	}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		configuration.planeDetection = [.vertical, .horizontal]
        sceneView.session.run(configuration)
		reloadConfiguration(removeAnchors: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    @IBAction func changeObjectMode(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            objectMode = .freeform
        case 1:
            objectMode = .plane
        case 2:
            objectMode = .image
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showOptions" {
            let optionsViewController = segue.destination as! OptionsContainerViewController
            optionsViewController.delegate = self
        }
    }
	
	
	var placedNodes:[SCNNode] = []
	var planeNodes:[SCNNode] = []
	
	
	// Detect touch
	// ------------------------------
	var lastObjectPlacedPoint: CGPoint?
	let touchDistanceThreshold: CGFloat = 20.0
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		guard let node = selectedNode,
			let touch = touches.first else { return }
		switch objectMode {
		case .freeform:
			addNodeInFront(node)
		case .plane:
			let touchPoint = touch.location(in: sceneView)
			addNode(node, toPlaneUsingPoint: touchPoint)
		case .image:
			break
		}
	}
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesMoved(touches, with: event)
		guard let node = selectedNode,
			let touch = touches.first,
			objectMode == .plane,
			let lastTouchPoint = lastObjectPlacedPoint else { return }
		let touchPoint = touch.location(in: sceneView)
		let distance = distanceBetween(touchPoint, lastTouchPoint)
		if distance > touchDistanceThreshold {
			addNode(node, toPlaneUsingPoint: touchPoint)
		}
	}
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesEnded(touches, with: event)
		lastObjectPlacedPoint = nil
	}
	
	func distanceBetween(_ point1: CGPoint, _ point2: CGPoint) -> CGFloat {
		let a = pow((point1.x - point2.x), 2.0)
		let b = pow((point1.y - point2.y), 2.0)
		return sqrt(a + b)
	}
	
	func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
		if let imageAnchor = anchor as? ARImageAnchor {
			nodeAdded(node, for: imageAnchor)
		} else if let planeAnchor = anchor as? ARPlaneAnchor {
			nodeAdded(node, for: planeAnchor)
		}
	}
	
	
	// Freeform objects
	// ------------------------------
	func addNodeInFront(_ node: SCNNode) {
		guard let camera = sceneView.session.currentFrame?.camera else { return }
		var translation = matrix_identity_float4x4
		translation.columns.3.z = -0.2
		node.simdTransform = matrix_multiply(camera.transform, translation)
		addNodeToSceneRoot(node)
	}
	func addNodeToSceneRoot(_ node: SCNNode) {
		let newNode = node.clone()
		sceneView.scene.rootNode.addChildNode(newNode)
		placedNodes.append(newNode)
	}
	
	
	// Image and plane detection
	// ------------------------------
	func nodeAdded(_ node: SCNNode, for imageAnchor: ARImageAnchor) {
		guard let selectedNode = selectedNode else { return }
		addNode(selectedNode, toImageUsingParentNode: node)
	}
	func addNode(_ node: SCNNode, toImageUsingParentNode parentNode: SCNNode) {
		let newNode = node.clone()
		parentNode.addChildNode(newNode)
		placedNodes.append(newNode)
	}
	
	func nodeAdded(_ node: SCNNode, for planeAnchor: ARPlaneAnchor) {
		print("floor node added")
		let floor = createFloor(anchor: planeAnchor)
		floor.isHidden = !showPlaneOverlay
		node.addChildNode(floor)
		planeNodes.append(floor)
	}
	func createFloor(anchor: ARPlaneAnchor) -> SCNNode {
		let node = SCNNode()
		let floor = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
		node.geometry = floor
		floor.firstMaterial?.diffuse.contents = UIColor.yellow
		floor.firstMaterial?.isDoubleSided = true
		node.eulerAngles.x -= .pi / 2
		node.opacity = 0.25
		return node
	}
	func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
		guard let planeAnchor = anchor as? ARPlaneAnchor,
			let node = node.childNodes.first,
			let floor = node.geometry as? SCNPlane else { return }
		node.position = SCNVector3(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
		floor.width = CGFloat(planeAnchor.extent.x)
		floor.height = CGFloat(planeAnchor.extent.z)
	}
	func addNode(_ node: SCNNode, toPlaneUsingPoint point: CGPoint) {
		let results = sceneView.hitTest(point, types: [.existingPlaneUsingExtent])
		guard let match = results.first else { return }
		let t = match.worldTransform
		node.position = SCNVector3(t.columns.3.x, t.columns.3.y, t.columns.3.z)
		addNodeToSceneRoot(node)
		lastObjectPlacedPoint = point
	}
	
	
	// Handle config object
	func reloadConfiguration(removeAnchors: Bool = true) {
		if objectMode == .image {
			configuration.detectionImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)
		} else {
			configuration.detectionImages = nil
		}
		let options: ARSession.RunOptions
		if removeAnchors {
			options = [.removeExistingAnchors]
			for node in planeNodes {
				node.removeFromParentNode()
			}
			planeNodes.removeAll()
			for node in placedNodes {
				node.removeFromParentNode()
			}
			placedNodes.removeAll()
		} else {
			options = []
		}
		sceneView.session.run(configuration, options: options)
	}
	
	// Toggle planes
	var showPlaneOverlay = true {
		didSet {
			for node in planeNodes {
				node.isHidden = !showPlaneOverlay
			}
		}
	}
}

extension ViewController: OptionsViewControllerDelegate {
	
	func objectSelected(node: SCNNode) {
        dismiss(animated: true, completion: nil)
		selectedNode = node
    }
    
    func togglePlaneVisualization() {
        dismiss(animated: true, completion: nil)
		showPlaneOverlay = !showPlaneOverlay
    }
    
    func undoLastObject() {
		guard let lastNode = placedNodes.last else { return }
		lastNode.removeFromParentNode()
		placedNodes.removeLast()
    }
    
    func resetScene() {
        dismiss(animated: true, completion: nil)
		reloadConfiguration()
    }
}
