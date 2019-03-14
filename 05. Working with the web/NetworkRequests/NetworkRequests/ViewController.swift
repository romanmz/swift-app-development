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
	@IBOutlet weak var otherItemsLabel: UILabel!
	
	
	// Initialize
	// ------------------------------
	override func viewDidLoad() {
		super.viewDidLoad()
		FeedController.fetchFeedItem(completion: feedItemLoaded(_:))
		FeedController.fetchFeedItems(completion: feetItemsLoaded(_:))
	}
	
	
	// Load feed item
	// ------------------------------
	func feedItemLoaded(_ item: FeedItem?) {
		guard let item = item else {
			print("there was an error fetching an item")
			return
		}
		DispatchQueue.main.async {
			self.itemDescription.text = item.description
			self.itemCopyright.text = item.copyright ?? ""
		}
		FeedController.fetchPhoto(from: item.url, completion: self.feedItemPhotoLoaded)
	}
	
	
	// Load photo
	// ------------------------------
	func feedItemPhotoLoaded(_ image: UIImage?) {
		guard let image = image else {
			print("there was an error fetching a photo")
			return
		}
		DispatchQueue.main.async {
			self.itemImage.image = image
		}
	}
	
	
	// Load feed items
	// ------------------------------
	func feetItemsLoaded(_ items: [FeedItem]?) {
		guard let items = items, items.count == 5 else {
			print("there was an error fetching a group of items")
			return
		}
		DispatchQueue.main.async {
			let itemsList = """
			Item 1: \(items[0].title)
			Item 2: \(items[1].title)
			Item 3: \(items[2].title)
			Item 4: \(items[3].title)
			Item 5: \(items[4].title)
			"""
			self.otherItemsLabel.text = itemsList
		}
	}
	
	
}
