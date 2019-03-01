//
//  MenuController.swift
//  Restaurant
//
//  Created by Román Martínez on 2/28/19.
//  Copyright © 2019 Roman Martinez. All rights reserved.
//

import Foundation
import UIKit


class MenuController {
	
	
	// Properties
	// ------------------------------
	
	// Static
	static let shared = MenuController()
	static let orderUpdatedNotification = Notification.Name("MenuController.orderUpdated")
	static let menuDataUpdatedNotification = Notification.Name("MenuController.menuDataUpdated")
	
	// Instance
	let baseURL = URL(string: "http://localhost:8090/")!
	let decoder = JSONDecoder()
	let encoder = JSONEncoder()
	var pendingRequests = 0
	
	// Persistent data
	var order = Order() {
		didSet {
			NotificationCenter.default.post(name: MenuController.orderUpdatedNotification, object: nil)
		}
	}
	
	
	// Network Activity Indicator
	// ------------------------------
	private func networkRequestBegan() {
		pendingRequests += 1
		DispatchQueue.main.async {
			UIApplication.shared.isNetworkActivityIndicatorVisible = true
		}
	}
	private func networkRequestEnded() {
		pendingRequests -= 1
		if pendingRequests <= 0 {
			DispatchQueue.main.async {
				UIApplication.shared.isNetworkActivityIndicatorVisible = false
			}
		}
	}
	
	
	// Cache Categories
	// ------------------------------
	var categories: [String] {
		get {
			return itemsByCategory.keys.sorted()
		}
	}
	
	
	// Cache Menu Items
	// ------------------------------
	private var itemsByID:[Int:MenuItem] = [:]
	private var itemsByCategory:[String:[MenuItem]] = [:]
	private func updateMenuItems(_ items: [MenuItem]) {
		itemsByID.removeAll()
		itemsByCategory.removeAll()
		for item in items {
			itemsByID[item.id] = item
			itemsByCategory[item.category, default: []].append(item)
		}
		DispatchQueue.main.async {
			NotificationCenter.default.post(name: MenuController.menuDataUpdatedNotification, object: nil)
		}
	}
	func item(withID itemID: Int) -> MenuItem? {
		return itemsByID[itemID]
	}
	func items(forCategory category: String) -> [MenuItem]? {
		return itemsByCategory[category]
	}
	
	
	// Persistent Orders
	// ------------------------------
	var orderFileURL: URL {
		get {
			let documentsDirectoryURI = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
			return documentsDirectoryURI.appendingPathComponent("order").appendingPathExtension("json")
		}
	}
	func loadOrder() {
		guard let data = try? Data(contentsOf: self.orderFileURL) else { return }
		order = (try? JSONDecoder().decode(Order.self, from: data)) ?? Order(menuItems:[])
	}
	func saveOrder() {
		if let data = try? self.encoder.encode(order) {
			try? data.write(to: self.orderFileURL)
		}
	}
	
	
	// Persistent Menu Items
	// ------------------------------
	var menuItemsFileURL: URL {
		get {
			let documentsDirectoryURI = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
			return documentsDirectoryURI.appendingPathComponent("menuItems").appendingPathExtension("json")
		}
	}
	func loadItems() {
		guard let data = try? Data(contentsOf: self.menuItemsFileURL) else { return }
		let items = (try? self.decoder.decode([MenuItem].self, from: data)) ?? []
		updateMenuItems(items)
	}
	func saveItems() {
		let items = Array(itemsByID.values)
		if let data = try? self.encoder.encode(items) {
			try? data.write(to: self.menuItemsFileURL)
		}
	}
	
	
	// Fetch Entire Menu
	// ------------------------------
	func fetchMenu() {
		networkRequestBegan()
		let initialMenuURL = baseURL.appendingPathComponent("menu")
		let components = URLComponents(url: initialMenuURL, resolvingAgainstBaseURL: true)!
		let menuURL = components.url!
		let task = URLSession.shared.dataTask(with: menuURL) {
			(data, _, _) in
			if let data = data, let menuItems = try? self.decoder.decode(MenuItems.self, from: data) {
				self.updateMenuItems(menuItems.items)
			}
			self.networkRequestEnded()
		}
		task.resume()
	}
	
	
	// Fetch Categories
	// ------------------------------
	func fetchCategories(completion: @escaping ([String]?)->Void) {
		networkRequestBegan()
		let url = baseURL.appendingPathComponent("categories")
		let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
			if let data = data,
				let categoriesObject = try? self.decoder.decode(Categories.self, from: data) {
				completion(categoriesObject.categories)
			} else {
				completion(nil)
			}
			self.networkRequestEnded()
		}
		task.resume()
	}
	
	
	// Fetch Menu Items
	// ------------------------------
	func fetchMenuItems(for category: String, completion: @escaping ([MenuItem]?)->Void) {
		
		// Prepare URL
		var url = baseURL.appendingPathComponent("menu")
		var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
		let queryItem = URLQueryItem(name: "category", value: category)
		urlComponents.queryItems = [queryItem]
		url = urlComponents.url!
		
		// Request data
		networkRequestBegan()
		let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
			if let data = data,
				let menuItems = try? self.decoder.decode(MenuItems.self, from: data) {
				completion(menuItems.items)
			} else {
				completion(nil)
			}
			self.networkRequestEnded()
		}
		task.resume()
	}
	
	
	// Submit Orders
	// ------------------------------
	func submitOrder(menuIds: [Int], completion: @escaping (Int?)->Void) {
		
		// Prepare URL
		let url = baseURL.appendingPathComponent("order")
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		
		// Prepare data to be sent
		let data: [String: [Int]] = ["menuIds": menuIds]
		let jsonData = try? self.encoder.encode(data)
		request.httpBody = jsonData
		
		// Fetch data
		networkRequestBegan()
		let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
			if let data = data,
				let time = try? self.decoder.decode(PreparationTime.self, from: data) {
				completion(time.prepTime)
			} else {
				completion(nil)
			}
			self.networkRequestEnded()
		}
		task.resume()
	}
	
	
	// Fetch Image
	// ------------------------------
	func fetchImage(url: URL, completion: @escaping (UIImage?)->Void) {
		networkRequestBegan()
		let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
			if let data = data,
				let image = UIImage(data: data) {
				completion(image)
			} else {
				completion(nil)
			}
			self.networkRequestEnded()
		}
		task.resume()
	}
	
	
}
