//
//  Types.swift
//  ARDrawingApp
//
//  Created by Román Martínez on 3/19/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import Foundation
import UIKit

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
