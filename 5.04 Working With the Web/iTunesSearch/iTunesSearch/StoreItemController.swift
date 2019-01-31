//
//  StoreItemController.swift
//  iTunesSearch
//
//  Created by Roman Martinez on 28/9/17.
//

import Foundation
import UIKit

class StoreItemController {
	
	
	func fetchItems(query: [String: String], onCompletion: @escaping ([StoreItem]?) -> Void) {
		// Prepare URL
		guard let baseUrl = URL(string: "https://itunes.apple.com/search"),
			let url = baseUrl.withQuery(query) else {
				print("Unable to build URL with supplied queries.")
				onCompletion(nil)
				return
		}
		// Prepare callback
		let callback = { (data: Data?, response: URLResponse?, error: Error?) -> Void in
			if let data = data,
				let rawJSON = try? JSONSerialization.jsonObject(with: data),
				let json = rawJSON as? [String: Any],
				let resultsArray = json["results"] as? [[String: Any]] {
				let storeItems = resultsArray.flatMap { StoreItem(json: $0) }
				onCompletion(storeItems)
			} else {
				onCompletion(nil)
			}
		}
		// Run task
		let task = URLSession.shared.dataTask(with: url, completionHandler: callback)
		task.resume()
	}
	
	
	func fetchImage(url: URL, onCompletion: @escaping (UIImage?) -> Void) {
		let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
			if let data = data,
				let image = UIImage(data: data) {
				onCompletion(image)
			} else {
				onCompletion(nil)
			}
		}
		task.resume()
	}
	
	
}
