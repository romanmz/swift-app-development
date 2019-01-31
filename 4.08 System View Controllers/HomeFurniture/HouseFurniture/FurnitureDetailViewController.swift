
import UIKit

class FurnitureDetailViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var furniture: Furniture?
    
    @IBOutlet weak var choosePhotoButton: UIButton!
    @IBOutlet weak var furnitureTitleLabel: UILabel!
    @IBOutlet weak var furnitureDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
    }
    
    func updateView() {
        guard let furniture = furniture else {return}
        if let imageData = furniture.imageData,
            let image = UIImage(data: imageData) {
            choosePhotoButton.setTitle("", for: .normal)
			choosePhotoButton.setBackgroundImage(image, for: .normal)
        } else {
            choosePhotoButton.setTitle("Choose Image", for: .normal)
            choosePhotoButton.setBackgroundImage(nil, for: .normal)
        }
        
        furnitureTitleLabel.text = furniture.name
        furnitureDescriptionLabel.text = furniture.description
    }
    
    @IBAction func choosePhotoButtonTapped(_ sender: UIButton) {
		
		// Init objects
		let alert = UIAlertController(title: "Add a photo for this item", message: nil, preferredStyle: .actionSheet)
		let imagePicker = UIImagePickerController()
		imagePicker.delegate = self
		
		// Action: Cancel
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		alert.addAction(cancelAction)
		
		// Action: Take photo
		if UIImagePickerController.isSourceTypeAvailable(.camera) {
			let cameraAction = UIAlertAction(title: "Take a photo", style: .default, handler: { action in
				imagePicker.sourceType = .camera
				self.present(imagePicker, animated: true, completion: nil)
			})
			alert.addAction(cameraAction)
		}
		
		// Action: Upload from library
		if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
			let photoUploadAction = UIAlertAction(title: "Choose from library", style: .default, handler: { action in
				imagePicker.sourceType = .photoLibrary
				self.present(imagePicker, animated: true, completion: nil)
			})
			alert.addAction(photoUploadAction)
		}
		
		// Open
		imagePicker.popoverPresentationController?.sourceView = sender
		present(alert, animated: true, completion: nil)
    }
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
			furniture?.imageData = UIImagePNGRepresentation(image)
		}
		dismiss(animated: true, completion: nil)
		updateView()
	}
	
	
    @IBAction func actionButtonTapped(_ sender: Any) {
		guard let furniture = furniture else { return }
		var shareItems: Array<Any> = []
		shareItems.append("\(furniture.name) – \(furniture.description)")
		if let imageData = furniture.imageData, let image = UIImage(data: imageData) {
			shareItems.append(image)
		}
		let activity = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
		present(activity, animated: true, completion: nil)
    }
	
	
}
