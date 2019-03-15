import UIKit


// Codable Protocol
// ------------------------------

// The properties of this struct all conform to the 'Codable' protocol,
// so the struct itself can also be declared as conforming without having to implement any properties or methods
struct Note: Codable {
	let title: String
	let text: String
	let timestamp: Date
}
let note1 = Note(title: "Note One", text: "This is a sample note.", timestamp: Date())
let note2 = Note(title: "Note Two", text: "This is another sample note.", timestamp: Date())
let note3 = Note(title: "Note Three", text: "This is yet another sample note.", timestamp: Date())
let notes = [note1, note2, note3]


// FileManager class
// ------------------------------

// Use the 'FileManager' class to get the paths to the writable folder for the app
let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
let archiveURL = documentsDirectory.appendingPathComponent("notes_test").appendingPathExtension("plist")
print(archiveURL)


// Encoder/Decoder: Property Lists (.plist files)
// ------------------------------

// Use the 'PropertyListEncoder' class to encode an instance in a way that can be saved to disk
let propertyListEncoder = PropertyListEncoder()
let encodedNotes = try? propertyListEncoder.encode(notes)
try? encodedNotes?.write(to: archiveURL, options: .noFileProtection)

// Use the 'PropertyListDecoder' to decode raw data and turn it into a type instance you can use
// You need to pass the expected type as the first argument of the 'decode' method
let propertyListDecoder = PropertyListDecoder()
if
	let retrievedNodesData = try? Data(contentsOf: archiveURL),
	let decodedNotes = try? propertyListDecoder.decode(Array<Note>.self, from: retrievedNodesData) {
	for note in decodedNotes {
		print(note)
	}
}


// Encoder/Decoder: JSON
// ------------------------------
// Use the JSONEncoder and JSONDecoder classes to handle .json files


// Network requests & State preservation
// ------------------------------

// By default an application will always load its initial view controller on launch,
// so it's safe to run any initializer code on that view

// However you can implement state preservation so that users won't lose their place on the application even if they closed it
// but this could cause issues if the preserved view depends on dynamic data that was meant to be loaded from the initial view
// in this case you can use the AppDelegate class to hook the necessary network calls on the app lifecycle events to ensure they will run
// regardless of which view is presented at launch

// If you're also implementing data persistence then you can load the stored data immediately on launch so users won't have to wait to use the app
// but at the same time request the updated data from the remote server so users can see the most up to date information as soon as possible
