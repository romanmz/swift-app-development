//
//  URLHelpers.swift
//  NetworkRequests
//
//  Created by Román Martínez on 3/13/19.
//  Copyright © 2019 Román Martínez. All rights reserved.
//

import Foundation


// Helper methods for handling URLs
// ------------------------------
extension URL {
	func withQueries(_ queries: [String:String]) -> URL? {
		var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
		components?.queryItems = queries.compactMap { URLQueryItem(name: $0.0, value: $0.1) }
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
