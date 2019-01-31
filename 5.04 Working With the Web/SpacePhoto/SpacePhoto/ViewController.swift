//
//  ViewController.swift
//  SpacePhoto
//
//  Created by Roman Martinez on 28/9/17.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	let photoController = PhotoInfoController()
	@IBOutlet weak var photoView: UIImageView!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var copyrightLabel: UILabel!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		descriptionLabel.text = ""
		copyrightLabel.text = ""
		photoView.image = nil
		photoController.fetchPhotoInfo { (photoInfo) in
			if let photoInfo = photoInfo {
				// Send to main thread:
				DispatchQueue.main.async {
					self.updateUI(with: photoInfo)
				}
			} else {
				print("there was an error fetching the data")
			}
		}
	}
	
	func updateUI(with photoInfo: PhotoInfo) {
		
		// Update UI
		title = photoInfo.title
		descriptionLabel.text = photoInfo.description
		if let copy = photoInfo.copyright {
			copyrightLabel.text = "Copyright \(copy)"
			copyrightLabel.isHidden = false
		} else {
			copyrightLabel.isHidden = true
		}
		
		// For testing exceptions for blocked http requests:
		// let insecureUrl = photoInfo.url.withHTTP()
		
		// Request photo
		photoController.fetchPhoto(from: photoInfo.url) { (image) in
			DispatchQueue.main.async {
				if let image = image {
					self.updatePhoto(with: image)
				} else {
					print("there was an error fetching the photo")
				}
				UIApplication.shared.isNetworkActivityIndicatorVisible = false
			}
		}
	}
	func updatePhoto(with image: UIImage) {
		photoView.image = image
	}
	
}
