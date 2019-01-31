//
//  PhotoInfo.swift
//  SpacePhoto
//
//  Created by Roman Martinez on 28/9/17.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import Foundation

struct PhotoInfo: Codable {
	var title: String
	var description: String
	var url: URL
	var copyright: String?
	
	enum CodingKeys: String, CodingKey {
		case title
		case description = "explanation"
		case url
		case copyright
	}
	init(from decoder: Decoder) throws {
		let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
		self.title = try valueContainer.decode(String.self, forKey: CodingKeys.title)
		self.description = try valueContainer.decode(String.self, forKey: CodingKeys.description)
		self.url = try valueContainer.decode(URL.self, forKey: CodingKeys.url)
		self.copyright = try? valueContainer.decode(String.self, forKey: CodingKeys.copyright)
	}
}
