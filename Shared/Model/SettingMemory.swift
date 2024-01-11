//
//  SettingMemory.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 5/24/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import Foundation

final class SettingMemory {

	var bytes: [UInt8]

	// MARK: -

	init?(size: Int) {
		// safety check
		guard size > 0 else {
			return nil
		}

		self.bytes = [UInt8](repeating: 0, count: size)
	}

	init?(string: String) {
		// safety check
		guard string.isEmpty == false, ((string.count % 2) == 0) else {
			return nil
		}

		self.bytes = [UInt8]()

		// parse the hex string
		let byteCount = (string.count >> 1)
		var byteStart = string.startIndex

		for _ in 0 ..< byteCount {
			let byteEnd = string.index(byteStart, offsetBy: 2)
			let byteString = string[byteStart ..< byteEnd]

			// parse the hex byte
			guard let byte = UInt8(byteString, radix: 16) else {
				return nil
			}

			// add the byte
			bytes.append(byte)

			// advance to the next byte
			byteStart = byteEnd
		}
	}

	var hexString: String {
		return bytes.map { String(format: "%02hhx", $0) }.joined()
	}

}
