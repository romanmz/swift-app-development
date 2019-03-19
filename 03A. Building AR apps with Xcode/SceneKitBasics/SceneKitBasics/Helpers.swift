//
//  Helpers.swift
//  SceneKitBasics
//
//  Created by Román Martínez on 3/18/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import Foundation


// Limit number of decimals
extension Double {
	var decimal: Double {
		return (self * 100).rounded() / 100
	}
}
