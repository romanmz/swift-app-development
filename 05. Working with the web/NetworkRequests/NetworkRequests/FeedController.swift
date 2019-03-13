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
	
	
	// Get feed item
	// ------------------------------
	static func fetchFeedItem(completion: @escaping (FeedItem?) -> Void ) {
		
		// Build URL
		let baseUrl = URL(string: "https://api.nasa.gov/planetary/apod")!
		let query = ["api_key":"DEMO_KEY", "date":"2000-10-10"]
		let url = baseUrl.withQueries(query)!
		
		// Prepare request
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		let task = URLSession.shared.dataTask(with: url) {
			
			// Callback
			(data, response, error) in
			DispatchQueue.main.async {
				UIApplication.shared.isNetworkActivityIndicatorVisible = false
			}
			guard error == nil,
				let data = data,
				let feedItem = try? self.decoder.decode(FeedItem.self, from: data) else {
					completion(nil)
					return
			}
			completion(feedItem)
		}
		
		// Send request
		task.resume()
	}
	
	
	// Get photo
	// ------------------------------
	static func fetchPhoto(from url: URL, completion: @escaping (UIImage?) -> Void) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		let task = URLSession.shared.dataTask(with: url) {
			(data, response, error) in
			DispatchQueue.main.async {
				UIApplication.shared.isNetworkActivityIndicatorVisible = false
			}
			guard error == nil,
				let data = data,
				let image = UIImage(data: data) else {
					completion(nil)
					return
			}
			completion(image)
		}
		task.resume()
	}
}
