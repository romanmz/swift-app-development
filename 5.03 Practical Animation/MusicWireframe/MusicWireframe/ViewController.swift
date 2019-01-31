//
//  ViewController.swift
//  MusicWireframe
//
//  Created by Roman Martinez on 27/9/17.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	var isPlaying: Bool = true {
		didSet {
			if isPlaying {
				playButton.setImage(UIImage(named: "pause")!, for: .normal)
			} else {
				playButton.setImage(UIImage(named: "play")!, for: .normal)
			}
		}
	}
	@IBOutlet weak var albumImage: UIImageView!
	@IBOutlet weak var reverseBackground: UIView!
	@IBOutlet weak var playBackground: UIView!
	@IBOutlet weak var nextBackground: UIView!
	@IBOutlet weak var reverseButton: UIButton!
	@IBOutlet weak var playButton: UIButton!
	@IBOutlet weak var nextButton: UIButton!
	@IBOutlet weak var playWidthConstraint: NSLayoutConstraint!
	
	
	@IBAction func playButtonTapped(_ sender: UIButton) {
		isPlaying = !isPlaying
		if isPlaying {
			UIView.animate(withDuration: 0.5, animations: {
				self.albumImage.transform = CGAffineTransform.identity
			})
		} else {
			UIView.animate(withDuration: 0.5, animations: {
				self.albumImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
			})
		}
	}
	
	func getBackgroundForButton(_ button: UIButton) -> UIView? {
		switch button {
		case reverseButton:
			return reverseBackground
		case nextButton:
			return nextBackground
		case playButton:
			return playBackground
		default:
			return nil
		}
	}
	@IBAction func touchedDown(_ sender: UIButton) {
		guard let background = getBackgroundForButton(sender) else { return }
		playWidthConstraint.constant = 40
		UIView.animate(withDuration: 0.25) {
			background.alpha = 0.5
			background.transform = CGAffineTransform(scaleX: 0.8, y:0.8)
			self.view.layoutIfNeeded()
		}
	}
	@IBAction func touchedUpInside(_ sender: UIButton) {
		guard let background = getBackgroundForButton(sender) else { return }
		playWidthConstraint.constant = 80
		UIView.animate(withDuration: 0.25, animations: {
			background.alpha = 0.0
			background.transform = CGAffineTransform(scaleX: 1.2, y:1.2)
			self.view.layoutIfNeeded()
		}) { _ in
			background.transform = CGAffineTransform.identity
		}
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		for bg in [reverseBackground, playBackground, nextBackground] {
			bg?.layer.cornerRadius = 40.0
			bg?.clipsToBounds = true
			bg?.alpha = 0
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}
