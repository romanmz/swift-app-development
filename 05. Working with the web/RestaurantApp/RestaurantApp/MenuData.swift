//
//  MenuData.swift
//  RestaurantApp
//
//  Created by Román Martínez on 3/14/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import Foundation
import UIKit


class MenuData {
	
	
	// Properties
	// ------------------------------
	
	// Network requests
	static let baseURL = URL(string: "http://localhost:8090/")!
	static var pendingRequests = 0
	
	// Events
	static let orderUpdatedNotification = Notification.Name("MenuData.orderUpdated")
	static let menuUpdatedNotification = Notification.Name("MenuData.menuUpdated")
	
	// Coders
	static let encoder = JSONEncoder()
	static let decoder = JSONDecoder()
	
	
	// Store data
	// ------------------------------
	
	// Menu items
	static var menuItems: [MenuItem] = [] {
		didSet {
			NotificationCenter.default.post(name: self.menuUpdatedNotification, object: nil)
		}
	}
	static func getMenuItems(withID id: Int) -> [MenuItem] {
		return menuItems.filter { item in item.id == id }
	}
	static func getMenuItems(withCategory category: String) -> [MenuItem] {
		return menuItems.filter { item in item.category == category }
	}
	
	// Categories
	static var categories: [String] {
		let categories = menuItems.map { item in item.category }
		return Array(Set(categories)).sorted()
	}
	
	// Customer order
	static var order = Order() {
		didSet {
			NotificationCenter.default.post(name: self.orderUpdatedNotification, object: nil)
		}
	}
	
	
	// Network activity indicator
	// ------------------------------
	static private func networkRequestStarted() {
		pendingRequests += 1
		DispatchQueue.main.async {
			UIApplication.shared.isNetworkActivityIndicatorVisible = true
		}
	}
	static private func networkRequestFinished() {
		pendingRequests -= 1
		if pendingRequests <= 0 {
			DispatchQueue.main.async {
				UIApplication.shared.isNetworkActivityIndicatorVisible = false
			}
		}
	}
	
	
	// Fetch entire menu
	// ------------------------------
	static func fetchMenuItems() {
		
		// Prepare URL
		let baseMenuURL = baseURL.appendingPathComponent("menu")
		let components = URLComponents(url: baseMenuURL, resolvingAgainstBaseURL: true)!
		let menuURL = components.url!
		
		// Prepare callback
		let callback = { (data: Data?, _: URLResponse?, _: Error?) -> Void in
			if let data = data, let menuItems = try? self.decoder.decode(MenuItems.self, from: data) {
				self.menuItems = menuItems.items
			}
			self.networkRequestFinished()
		}
		
		// Submit request
		networkRequestStarted()
		let task = URLSession.shared.dataTask(with: menuURL, completionHandler: callback)
		task.resume()
	}
	
	
	// Fetch image
	// ------------------------------
	static func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
		networkRequestStarted()
		let task = URLSession.shared.dataTask(with: url) {
			(data, _, _) in
			self.networkRequestFinished()
			if let data = data, let image = UIImage(data: data) {
				completion(image)
				return
			}
			completion(nil)
		}
		task.resume()
	}
	
	
}
