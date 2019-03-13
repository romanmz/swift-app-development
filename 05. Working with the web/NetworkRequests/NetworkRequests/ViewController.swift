//
//  ViewController.swift
//  NetworkRequests
//
//  Created by Román Martínez on 3/13/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	
	// Interface builder outlets
	// ------------------------------
	@IBOutlet weak var itemImage: UIImageView!
	@IBOutlet weak var itemDescription: UILabel!
	@IBOutlet weak var itemCopyright: UILabel!
	
	
	// Load feed item
	// ------------------------------
	override func viewDidLoad() {
		super.viewDidLoad()
		FeedController.fetchFeedItem(completion: feedItemLoaded(_:))
	}
	func feedItemLoaded(_ item: FeedItem?) {
		if let item = item {
			DispatchQueue.main.async {
				self.itemDescription.text = item.description
				self.itemCopyright.text = item.copyright ?? ""
			}
			FeedController.fetchPhoto(from: item.url, completion: self.feedItemPhotoLoaded)
		} else {
			print("there was an error fetching the data")
		}
	}
	func feedItemPhotoLoaded(_ image: UIImage?) {
		if let image = image {
			DispatchQueue.main.async {
				self.itemImage.image = image
			}
		} else {
			print("there was an error fetching the photo")
		}
	}
	
	
}
