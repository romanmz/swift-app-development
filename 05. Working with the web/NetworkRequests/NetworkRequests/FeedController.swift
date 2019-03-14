//
//  FeedController.swift
//  NetworkRequests
//
//  Created by Román Martínez on 3/13/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import Foundation
import UIKit


// Feed Controller
// ==============================
// Use the URLSession.shared.dataTask() method to make requests to a URL
// The UIApplication.shared.isNetworkActivityIndicatorVisible property toggles on or off the network activity indicator on the device
// Use the DispatchQueue.main.async method to run asynchronous code in the main thread

class FeedController {
	
	
	// Properties
	// ------------------------------
	static let decoder = JSONDecoder()
	static var pendingRequests = 0
	
	
	// Generic network requests
	// ------------------------------
	static func beginRequest() {
		self.pendingRequests += 1
		DispatchQueue.main.async {
			UIApplication.shared.isNetworkActivityIndicatorVisible = true
		}
	}
	static func finishedRequest() {
		self.pendingRequests -= 1
		if self.pendingRequests <= 0 {
			DispatchQueue.main.async {
				UIApplication.shared.isNetworkActivityIndicatorVisible = false
			}
		}
	}
	static func fetchData(query: [String:String], completion: @escaping (Data?) -> Void) {
		
		// Build URL
		let baseUrl = URL(string: "https://api.nasa.gov/planetary/apod")!
		let query = ["api_key":"DEMO_KEY"].merging(query) { (current, _) in current }
		let url = baseUrl.withQueries(query)!
		
		// Prepare callback
		let resultHandler = {
			(data: Data?, response: URLResponse?, error: Error?) -> Void in
			self.finishedRequest()
			if error == nil, let data = data {
				completion(data)
				return
			}
			completion(nil)
		}
		
		// Begin request
		self.beginRequest()
		let task = URLSession.shared.dataTask(with: url, completionHandler: resultHandler)
		task.resume()
	}
	
	
	// Get feed item (Using the Codable protocol)
	// ------------------------------
	static func fetchFeedItem(completion: @escaping (FeedItem?) -> Void ) {
		self.fetchData(query: [:]) {
			(data) in
			guard
				let data = data,
				let feedItem = try? self.decoder.decode(FeedItem.self, from: data) else {
					completion(nil)
					return
			}
			completion(feedItem)
		}
	}
	
	
	// Get feed items (Manuall converting a json Dict)
	// ------------------------------
	static func fetchFeedItems(completion: @escaping ([FeedItem]?) -> Void ) {
		self.fetchData(query: ["start_date":"2019-01-01", "end_date":"2019-01-05"]) {
			(data) in
			guard
				let data = data,
				let rawJSON = try? JSONSerialization.jsonObject(with: data),
				let json = rawJSON as? [[String: Any]] else {
					completion(nil)
					return
			}
			let feedItems = json.compactMap { FeedItem(json: $0) }
			completion(feedItems)
		}
	}
	
	
	// Get photo
	// ------------------------------
	static func fetchPhoto(from url: URL, completion: @escaping (UIImage?) -> Void) {
		
		// Prepare callback
		let resultHandler = {
			(data: Data?, response: URLResponse?, error: Error?) -> Void in
			self.finishedRequest()
			guard
				error == nil,
				let data = data,
				let image = UIImage(data: data) else {
					completion(nil)
					return
			}
			completion(image)
		}
		
		// Begin request
		self.beginRequest()
		let task = URLSession.shared.dataTask(with: url, completionHandler: resultHandler)
		task.resume()
	}
}
