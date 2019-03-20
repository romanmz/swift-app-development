//
//  Types.swift
//  ARDrawingApp
//
//  Created by Román Martínez on 3/19/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import Foundation
import UIKit
import SceneKit


// Shape
// ------------------------------
enum Shape: String {
	case box = "Box"
	case sphere = "Sphere"
	case cylinder = "Cylinder"
	case cone = "Cone"
	case torus = "Torus"
	func createGeometry(size: CGFloat) -> SCNGeometry {
		switch self {
		case .box:
			return SCNBox(width: size, height: size, length: size, chamferRadius: 0.0)
		case .sphere:
			return SCNSphere(radius: size / 2)
		case .cylinder:
			return SCNCylinder(radius: size / 2, height: size)
		case .cone:
			return SCNCone(topRadius: 0.0, bottomRadius: size / 2, height: size)
		case .torus:
			return SCNTorus(ringRadius: size / 2, pipeRadius: size * 0.2)
		}
	}
	static var all: [Shape] {
		return [.box, .sphere, .cylinder, .cone, .torus]
	}
}


// Size
// ------------------------------
enum Size: String {
	case small = "Small"
	case medium = "Medium"
	case large = "Large"
	var value: CGFloat {
		switch self {
		case .small:
			return 0.033
		case .medium:
			return 0.1
		case .large:
			return 0.3
		}
	}
	static var all: [Size] {
		return [.small, .medium, .large]
	}
}


// Color
// ------------------------------
enum Color: String {
	case red = "Red"
	case yellow = "Yellow"
	case orange = "Orange"
	case green = "Green"
	case blue = "Blue"
	case brown = "Brown"
	case white = "White"
	var value: UIColor {
		switch self {
		case .red: return .red
		case .yellow: return .yellow
		case .orange: return .orange
		case .green: return .green
		case .blue: return .blue
		case .brown: return .brown
		case .white: return .white
		}
	}
	static var all: [Color] {
		return [.red, .yellow, .orange, .green, .blue, .brown, .white]
	}
}
