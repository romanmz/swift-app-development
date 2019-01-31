//
//  ViewController.swift
//  ISpy
//
//  Created by Roman Martinez on 22/09/2017.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
	
	
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var imageView: UIImageView!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		scrollView.delegate = self
		updateZoomFor(size: view.bounds.size)
	}
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return imageView
	}
	func updateZoomFor(size: CGSize) {
		let widthScale = size.width / imageView.bounds.width
		let heightScale = size.height / imageView.bounds.height
		let scale = max(widthScale, heightScale)
		scrollView.minimumZoomScale = scale
		scrollView.maximumZoomScale = 2.0
	}
	
	
}
