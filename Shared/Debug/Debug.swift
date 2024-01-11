//
//  Debug.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 5/26/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import Foundation

class Debug {

	static func error(_ string: String) {
		print(string)
	}

	static func error(_ category: String, _ string: String) {
		print("\(category): \(string)")
	}

	static func log(_ string: String) {
		print(string)
	}

	static func log(_ category: String, _ string: String) {
		print("\(category): \(string)")
	}

}

// MARK: -

extension Data {

	var hexString: String {
		return self.map { String(format: "%02hhx", $0) }.joined()
	}

}

// MARK: -

extension String {

	func indent(_ tabs: Int = 1) -> String {
		// create the indent
		var indent = ""
		for _ in 0 ..< tabs {
			indent += "\t"
		}

		// indent each line
		let lines = self.split(separator: "\n")
		var result = ""
		for line in lines {
			result += (indent + line + "\n")
		}

		return result
	}

}
