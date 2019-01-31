//
//  URLHelpers.swift
//  SpacePhoto
//
//  Created by Roman Martinez on 28/9/17.
//  Copyright © 2017 Roman Martinez. All rights reserved.
//

import Foundation

extension URL {
	func withQueries(_ queries: [String:String]) -> URL? {
		var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
		components?.queryItems = queries.flatMap { URLQueryItem(name: $0.0, value: $0.1) }
		return components?.url
	}
	func withHTTPS() -> URL? {
		var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
		components?.scheme = "https"
		return components?.url
	}
	func withHTTP() -> URL? {
		var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
		components?.scheme = "http"
		return components?.url
	}
}
