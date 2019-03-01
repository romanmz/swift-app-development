//
//  Helpers.swift
//  Restaurant
//
//  Created by Roman Martinez on 28/9/17.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {
	func errorAlert(title: String?, message: String?) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
		alert.addAction(dismissAction)
		present(alert, animated: true, completion: nil)
	}
}


class MenuController {
	
	
	// Properties
	// ------------------------------
	static let shared = MenuController()
	let baseURL = URL(string: "http://localhost:8090/")!
	let decoder = JSONDecoder()
	var pendingRequests = 0
	var order = Order()
	
	
	// Methods
	// ------------------------------
	private func networkRequestBegan() {
		pendingRequests += 1
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
	}
	private func networkRequestEnded() {
		pendingRequests -= 1
		if pendingRequests <= 0 {
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
		}
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
		let jsonEncoder = JSONEncoder()
		let jsonData = try? jsonEncoder.encode(data)
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
