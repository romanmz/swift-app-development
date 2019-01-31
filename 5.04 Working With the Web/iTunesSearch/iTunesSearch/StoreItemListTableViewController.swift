
import UIKit

class StoreItemListTableViewController: UITableViewController {
	
	// Properties
	var items: [StoreItem] = []
	let storeItemController = StoreItemController()
	let queryOptions = ["movie", "music", "software", "ebook"]
	
	// Outlets
	@IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterSegmentedControl: UISegmentedControl!
	
	// Methods
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	@IBAction func filterOptionUpdated(_ sender: UISegmentedControl) {
		fetchMatchingItems()
	}
	func fetchMatchingItems() {
		self.items = []
		self.tableView.reloadData()
		
		let searchTerm = searchBar.text ?? ""
		let mediaType = queryOptions[filterSegmentedControl.selectedSegmentIndex]
		guard !searchTerm.isEmpty else { return }
		
		// Init request
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		let query = [
			"term": searchTerm,
			"media": mediaType,
			"country": "AU",
			"limit": "10",
		]
		storeItemController.fetchItems(query: query, onCompletion: { (items) in
			DispatchQueue.main.async {
				if let newItems = items {
					self.items = newItems
					self.tableView.reloadData()
				} else {
					print("There was an error while fetching the data")
				}
				UIApplication.shared.isNetworkActivityIndicatorVisible = false
			}
		})
		
    }
    func configure(cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let item = items[indexPath.row]
		cell.textLabel?.text = "\(item.name) - \(item.artist)"
		cell.detailTextLabel?.text = item.description
		cell.imageView?.image = UIImage(imageLiteralResourceName: "gray")
		
		// Init request
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		storeItemController.fetchImage(url: item.artworkURL) { (image) in
			DispatchQueue.main.async {
				if let artwork = image {
					cell.imageView?.image = artwork
				} else {
					print("Could not fetch artwork for \(item.name)")
				}
				UIApplication.shared.isNetworkActivityIndicatorVisible = false
			}
		}
		
    }
	
	
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        configure(cell: cell, forItemAt: indexPath)
		return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
	
}


extension StoreItemListTableViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchMatchingItems()
        searchBar.resignFirstResponder()
    }
}
