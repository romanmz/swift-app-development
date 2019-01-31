//
//  URLHelpers.swift
//  iTunesSearch
//
//  Created by Roman Martinez on 28/9/17.
//

import Foundation

extension URL {
	func withQuery(_ query: [String:String]) -> URL? {
		var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
		components?.queryItems = query.flatMap { URLQueryItem(name: $0.0, value: $0.1) }
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
