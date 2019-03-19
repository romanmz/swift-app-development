//
//  Option.swift
//  ARDrawingApp
//
//  Created by Román Martínez on 3/19/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import Foundation

enum MenuOption: String {
	case addShape = "Select Basic Shape"
	case addScene = "Select Scene File"
	case togglePlanes = "Toggle Planes Visibility"
	case undo = "Undo Last Shape"
	case reset = "Reset Scene"
	static var all: [MenuOption] {
		return [.addShape, .addScene, .togglePlanes, .undo, .reset]
	}
}
