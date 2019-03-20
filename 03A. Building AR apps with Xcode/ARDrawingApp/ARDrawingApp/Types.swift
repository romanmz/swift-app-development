//
//  Types.swift
//  ARDrawingApp
//
//  Created by Román Martínez on 3/19/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import Foundation

enum Shape: String {
	case box = "Box"
	case sphere = "Sphere"
	case cylinder = "Cylinder"
	case cone = "Cone"
	case torus = "Torus"
	static var all: [Shape] {
		return [.box, .sphere, .cylinder, .cone, .torus]
	}
}
enum Size: String {
	case small = "Small"
	case medium = "Medium"
	case large = "Large"
	static var all: [Size] {
		return [.small, .medium, .large]
	}
}
