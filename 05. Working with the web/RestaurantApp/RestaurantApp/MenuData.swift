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
	static func getMenuItem(withID id: Int) -> MenuItem? {
		for item in menuItems {
			if item.id == id {
				return item
			}
		}
		return nil
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
	static func fetchMenuItems(completion: @escaping ([MenuItem]?) -> Void) {
		
		// Prepare URL
		let baseMenuURL = baseURL.appendingPathComponent("menu")
		let components = URLComponents(url: baseMenuURL, resolvingAgainstBaseURL: true)!
		let menuURL = components.url!
		
		// Submit request
		networkRequestStarted()
		let task = URLSession.shared.dataTask(with: menuURL) {
			(data, _, _) in
			
			// Callback
			self.networkRequestFinished()
			guard let data = data,
				let menuItems = try? self.decoder.decode(MenuItems.self, from: data) else {
				completion(nil)
				return
			}
			completion(menuItems.items)
		}
		task.resume()
	}
	
	
	// Fetch image
	// ------------------------------
	static func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
		networkRequestStarted()
		let task = URLSession.shared.dataTask(with: url) {
			(data, _, _) in
			self.networkRequestFinished()
			guard let data = data,
				let image = UIImage(data: data) else {
				completion(nil)
				return
			}
			completion(image)
		}
		task.resume()
	}
	
	
	// Submit orders
	// ------------------------------
	static func submitOrder(order: Order, completion: @escaping (Int?)->Void) {
		
		// Prepare request
		let url = baseURL.appendingPathComponent("order")
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		
		// Prepare data to be sent
		let menuIds = order.menuItems.map { $0.id }
		let data: [String: [Int]] = ["menuIds": menuIds]
		let jsonData = try? encoder.encode(data)
		request.httpBody = jsonData
		
		// Fetch data
		networkRequestStarted()
		let task = URLSession.shared.dataTask(with: request) {
			(data, response, error) in
			
			// Callback
			self.networkRequestFinished()
			guard let data = data,
				let time = try? self.decoder.decode(PreparationTime.self, from: data) else {
				completion(nil)
				return
			}
			completion(time.prepTime)
		}
		task.resume()
	}
	
	
	// Persistent data
	// ------------------------------
	static var documentsURL: URL {
		return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
	}
	
	// Orders
	static var orderFileURL: URL {
		return documentsURL.appendingPathComponent("order").appendingPathExtension("json")
	}
	static func loadOrderFromFile() {
		guard let data = try? Data(contentsOf: orderFileURL) else { return }
		order = (try? decoder.decode(Order.self, from: data)) ?? Order(menuItems:[])
	}
	static func saveOrderToFile() {
		guard let data = try? encoder.encode(order) else { return }
		try? data.write(to: orderFileURL)
	}
	
	// Menu items
	static var menuItemsFileURL: URL {
		return documentsURL.appendingPathComponent("menuItems").appendingPathExtension("json")
	}
	static func loadItemsFromFile() {
		guard let data = try? Data(contentsOf: menuItemsFileURL) else { return }
		menuItems = (try? decoder.decode([MenuItem].self, from: data)) ?? []
	}
	static func saveItemsToFile() {
		guard let data = try? encoder.encode(menuItems) else { return }
		try? data.write(to: menuItemsFileURL)
	}
	
	
}
