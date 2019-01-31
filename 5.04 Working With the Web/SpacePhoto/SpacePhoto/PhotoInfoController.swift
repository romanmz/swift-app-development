//
//  PhotoInfoController.swift
//  SpacePhoto
//
//  Created by Roman Martinez on 28/9/17.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import Foundation
import UIKit

class PhotoInfoController {
	
	func fetchPhotoInfo(completion: @escaping (PhotoInfo?) -> Void ) {
		let baseUrl = URL(string: "https://api.nasa.gov/planetary/apod")!
		let query = ["api_key":"DEMO_KEY", "date":"2000-10-10"]
		let url = baseUrl.withQueries(query)!
		let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
			let jsonDecoder = JSONDecoder()
			guard error == nil,
				let data = data,
				let photoInfo = try? jsonDecoder.decode(PhotoInfo.self, from: data) else {
					completion(nil)
					return
			}
			// let dataString = String(data: data, encoding: .utf8)
			completion(photoInfo)
		}
		task.resume()
	}
	
	func fetchPhoto(from url: URL, completion: @escaping (UIImage?) -> Void) {
		let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
			guard let data = data,
				let image = UIImage(data: data) else {
					completion(nil)
					return
			}
			completion(image)
		}
		task.resume()
	}
	
}
