//
//  ViewController.swift
//  SystemViewControllers
//
//  Created by Román Martínez on 3/11/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import UIKit
import SafariServices
import MessageUI

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
	@IBOutlet weak var imageView: UIImageView!
	
	
	// UIActivityViewController (Sharing popup)
	// ------------------------------
	// Info.plist row for requesting permission to save images to the photo library: NSPhotoLibraryAddUsageDescription
	@IBAction func shareButtonPressed(_ sender: UIButton) {
		guard let image = imageView.image else { return }
		let activityController = UIActivityViewController(activityItems: [image, "Photo name"], applicationActivities: nil)
		activityController.popoverPresentationController?.sourceView = sender
		present(activityController, animated: true, completion: nil)
	}
	
	
	// SFSafariViewController (Browser popup)
	// ------------------------------
	// requires "SafariServices"
	@IBAction func browserButtonPressed(_ sender: UIButton) {
		guard let url = URL(string: "https://romanmartinez.me") else { return }
		let safariController = SFSafariViewController(url: url)
		safariController.popoverPresentationController?.sourceView = sender
		present(safariController, animated: true, completion: nil)
	}
	
	
	// UIAlertController (Alerts)
	// UIImagePickerController (Image picker)
	// ------------------------------
	// Info.plist row for requesting access to the photo library: NSPhotoLibraryUsageDescription
	// Info.plist row for requesting access to the device camera: NSCameraUsageDescription
	// requires conformance to the UIImagePickerControllerDelegate and UINavigationControllerDelegate protocols
	@IBAction func uploadButtonPressed(_ sender: UIButton) {
		
		// Init alert object
		let alertController = UIAlertController(
			title: "Choose image source",
			message: "you can take a new photo or upload an existing one from your library",
			preferredStyle: .actionSheet
		)
		
		// Add 'cancel' action
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		alertController.addAction(cancelAction)
		
		// Init image picker
		let imagePicker = UIImagePickerController()
		imagePicker.delegate = self
		
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
	
	// Image picker callback (delegate method)
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let image = info[.originalImage] as? UIImage else { return }
		imageView.image = image
		dismiss(animated: true, completion: nil)
	}
	
	
	// mailComposeController (Email composer popup)
	// ------------------------------
	// requires "MessageUI"
	// requires conformance to MFMailComposeViewControllerDelegate protocol
	@IBAction func emailButtonPressed(_ sender: UIButton) {
		guard MFMailComposeViewController.canSendMail() else { return }
		
		// Init
		let mailComposer = MFMailComposeViewController()
		mailComposer.mailComposeDelegate = self
		
		// Configure
		mailComposer.setToRecipients(["roman.mx3@gmail.com", "hello@romanmartinez.me"])
		mailComposer.setSubject("check this out!")
		mailComposer.setMessageBody("<h1>Lorem ipsum</h1><p>I just took this pic</p>", isHTML: true)
		if let image = imageView.image, let imageData = image.jpegData(compressionQuality: 0.8) {
			mailComposer.addAttachmentData(imageData, mimeType: "image/jpeg", fileName: "attached-image.jpg")
		}
		
		// Open
		mailComposer.popoverPresentationController?.sourceView = sender
		present(mailComposer, animated: true, completion: nil)
	}
	
	// Mail composer callback (delegate method)
	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		dismiss(animated: true, completion: nil)
	}
	
	
	// SMS (Text message composer)
	// ------------------------------
	// requires "MessageUI"
	// requires conformance to MFMessageComposeViewControllerDelegate protocol
	@IBAction func smsButtonPressed(_ sender: UIButton) {
		guard MFMessageComposeViewController.canSendText() else { return }
		
		// Init
		let messageComposer = MFMessageComposeViewController()
		messageComposer.messageComposeDelegate = self
		
		// Configure
		messageComposer.recipients = ["+524491859984"]
		messageComposer.body = "this is a test message"
		
		messageComposer.popoverPresentationController?.sourceView = sender
		present(messageComposer, animated: true, completion: nil)
	}
	
	// Text message composer callback (delegate method)
	func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
		dismiss(animated: true, completion: nil)
	}
	
	
}
