//
//  ViewController.swift
//  SystemViewControllers
//
//  Created by Roman Martinez on 25/09/2017.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import UIKit
import SafariServices
import MessageUI


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
	
	
	@IBOutlet weak var imageView: UIImageView!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	@IBAction func shareButtonTapped(_ sender: UIButton) {
		guard let image = imageView.image else { return }
		let activityController = UIActivityViewController(activityItems: [image, "Photo name"], applicationActivities: nil)
		activityController.popoverPresentationController?.sourceView = sender
		present(activityController, animated: true, completion: nil)
	}
	@IBAction func safariButtonTapped(_ sender: UIButton) {
		guard let url = URL(string: "http://romanmartinez.me") else { return }
		let safariController = SFSafariViewController(url: url)
		safariController.popoverPresentationController?.sourceView = sender
		present(safariController, animated: true, completion: nil)
	}
	
	
	// Image Picker
	// --------------------------------------------------
	@IBAction func cameraButtonTapped(_ sender: UIButton) {
		
		// Init objects
		let alertController = UIAlertController(
			title: "Choose image source",
			message: "you can take a new photo or upload an existing one from your library",
			preferredStyle: .actionSheet
		)
		let imagePicker = UIImagePickerController()
		imagePicker.delegate = self
		
		// Add 'cancel' action
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		alertController.addAction(cancelAction)
		
		// Add camera control
		if UIImagePickerController.isSourceTypeAvailable(.camera) {
			let cameraAction = UIAlertAction(title: "Take a photo", style: .default, handler: {
				alertAction in
				imagePicker.sourceType = .camera
				self.present(imagePicker, animated: true, completion: nil)
			})
			alertController.addAction(cameraAction)
		}
		
		// Add image uploads
		if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
			let libraryAction = UIAlertAction(title: "Upload from your library", style: .default, handler: {
				alertAction in
				imagePicker.sourceType = .photoLibrary
				self.present(imagePicker, animated: true, completion: nil)
			})
			alertController.addAction(libraryAction)
		}
		
		// Open
		alertController.popoverPresentationController?.sourceView = sender
		present(alertController, animated: true, completion: nil)
	}
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		guard let image = info["UIImagePickerControllerOriginalImage"] as? UIImage else { return }
		imageView.image = image
		dismiss(animated: true, completion: nil)
	}
	
	
	// Mail Composer
	// --------------------------------------------------
	@IBAction func emailButtonTapped(_ sender: UIButton) {
		guard MFMailComposeViewController.canSendMail() else { return }
		
		// Init
		let mailComposer = MFMailComposeViewController()
		mailComposer.mailComposeDelegate = self
		
		// Configure
		mailComposer.setToRecipients(["roman.mx3@gmail.com", "hello@romanmartinez.me"])
		mailComposer.setSubject("check this out!")
		mailComposer.setMessageBody("<h1>Lorem ipsum</h1><p>I just took this pic</p>", isHTML: true)
		if let image = imageView.image, let imageData = UIImageJPEGRepresentation(image, 0.8) {
			mailComposer.addAttachmentData(imageData, mimeType: "image/jpeg", fileName: "attached-image.jpg")
		}
		
		// Open
		mailComposer.popoverPresentationController?.sourceView = sender
		present(mailComposer, animated: true, completion: nil)
	}
	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		dismiss(animated: true, completion: nil)
	}
	
	
	// Message Composer
	// --------------------------------------------------
	@IBAction func textButtonTapped(_ sender: UIButton) {
		guard MFMessageComposeViewController.canSendText() else { return }
		
		// Init
		let messageComposer = MFMessageComposeViewController()
		messageComposer.messageComposeDelegate = self
		
		// Configure
		messageComposer.recipients = ["0403413433"]
		messageComposer.body = "this is a test message"
		
		messageComposer.popoverPresentationController?.sourceView = sender
		present(messageComposer, animated: true, completion: nil)
	}
	func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
		dismiss(animated: true, completion: nil)
	}
	
	
}
