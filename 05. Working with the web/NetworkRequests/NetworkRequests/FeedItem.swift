//
//  FeedItem.swift
//  NetworkRequests
//
//  Created by Román Martínez on 3/13/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import Foundation


// Codable protocol
// ------------------------------
// When receiving an item from a json feed you could decode it as a simple Dictionary<String,String>
// but you can also define your own custom type and convert the json item into this type
// the custom type needs to conform to the "Codable" protocol

// When defining the CodingKeys you can load attributes and change their names to something else
// in this example, there's an "explanation" property on the feed item, but we're importing it as "description"

struct FeedItem: Codable {
	var title: String
	var description: String
	var url: URL
	var copyright: String?
	
	enum CodingKeys: String, CodingKey {
		case title, description = "explanation", url, copyright
	}
	init(from decoder: Decoder) throws {
		let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
		self.title = try valueContainer.decode(String.self, forKey: CodingKeys.title)
		self.description = try valueContainer.decode(String.self, forKey: CodingKeys.description)
		self.url = try valueContainer.decode(URL.self, forKey: CodingKeys.url)
		self.copyright = try? valueContainer.decode(String.self, forKey: CodingKeys.copyright)
	}
}
