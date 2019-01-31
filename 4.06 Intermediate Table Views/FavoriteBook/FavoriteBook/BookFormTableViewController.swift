//
//  BookFormTableViewController.swift
//  FavoriteBooks
//
//  Created by Roman Martinez on 24/09/2017.
//
//

import UIKit

class BookFormTableViewController: UITableViewController {
	
	
	// Nested types
	struct PropertyKeys {
		static let unwind = "UnwindToBookTable"
	}
	
	
	// Properties
	var book: Book?
	
	@IBOutlet weak var titleTextField: UITextField!
	@IBOutlet weak var authorTextField: UITextField!
	@IBOutlet weak var genreTextField: UITextField!
	@IBOutlet weak var lengthTextField: UITextField!
	
	
	// Methods
	override func viewDidLoad() {
		super.viewDidLoad()
		updateView()
	}
	func updateView() {
		guard let book = book else {return}
		titleTextField.text = book.title
		authorTextField.text = book.author
		genreTextField.text = book.genre
		lengthTextField.text = book.length
	}
	@IBAction func buttonPressed(_ sender: UIButton) {
		guard let title = titleTextField.text,
			let author = authorTextField.text,
			let genre = genreTextField.text,
			let length = lengthTextField.text else {return}
		
		book = Book(title: title, author: author, genre: genre, length: length)
		performSegue(withIdentifier: PropertyKeys.unwind, sender: self)
	}
	
	
}
