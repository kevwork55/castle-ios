//
//  ClassicRequests.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 6/7/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import Foundation

class ClassicRequest<T>: BluetoothResponseRequest<T> {

	enum RequestType: UInt8 {
		case bootloaderVersion = 0x05
		case getProgramValues = 0x06
		case linkVersion = 0x12
	}

	init(completion: @escaping ((T?) -> Void)) {
		super.init(characteristic: .classic, headerSize: 5, dataSize: 8)
		self.completion = completion

		// set the magic value
		data[0] = 0x43
		// reset the data to 0xFF
		for index in headerSize ..< totalSize {
			data[index] = 0xFF
		}
		// set invalid address for safety
		data[3] = 0xFF
	}

	fileprivate func calculateChecksum() {
		data[2] = calculateChecksum(data)
	}

	fileprivate func calculateChecksum(_ data: Data) -> UInt8 {
		var checksum = 0
		for index in 0 ..< data.count {
			if (index != 2) {
				checksum = ((checksum + Int(data[index])) & 0xFF)
			}
		}
		return UInt8((0x100 - checksum) & 0xFF)
	}

}

// MARK: -

final class BootloaderVersionRequest: ClassicRequest<String> {

	override init(completion: @escaping ((String?) -> Void)) {
		super.init(completion: completion)
		// build the request
		data[1] = RequestType.bootloaderVersion.rawValue
		data[3] = 0x00
		calculateChecksum()
	}

	override func parseResult(data: Data) -> String? {
		// safety check the response makes sense
		guard (data[0] == 0x43), (data.count >= 13) else {
			Debug.error("BluetoothRequest", "Error in bootloader version response.")
			return nil
		}

		return String(data: data[5 ..< 12], encoding: .utf8)
	}

}

// MARK: -

final class GetProgramValuesRequest: ClassicRequest<GetProgramValuesRequest.Result> {

	struct Result {
		let address: UInt16
		let data: Data
	}

	var address: UInt16

	init(address: UInt16, completion: @escaping ((Result?) -> Void)) {
		// safety check
		if ((address & 0x07) != 0) {
			Debug.error("ClassicRequests", "Get program values called with invalid address.")
		}

		// init
		self.address = address
		super.init(completion: completion)

		// build the request
		let memoryIndex = (address >> 3)
		data[1] = RequestType.getProgramValues.rawValue
		data[3] = UInt8((memoryIndex >> 8) & 0xFF)
		data[4] = UInt8(memoryIndex & 0xFF)
		calculateChecksum()
	}

	override func parseResult(data: Data) -> Result? {
		// safety check the response
		guard (data[0] == 0x43), (data[1] == 0x06), (data.count >= 13),
			  (data[2] == calculateChecksum(data)) else {
			Debug.error("BluetoothRequest", "Error in get program values response.")
			return nil
		}

		return Result(address: self.address, data: data[5 ..< 13])
	}

}

// MARK: -

final class LinkVersionRequest: ClassicRequest<String> {

	override init(completion: @escaping ((String?) -> Void)) {
		super.init(completion: completion)
		// build the request
		data[1] = RequestType.linkVersion.rawValue
		data[3] = 0x00
		calculateChecksum()
	}

	override func parseResult(data: Data) -> String? {
		// safety check the response makes sense
		guard (data[0] == 0x43), (data.count >= 13) else {
			Debug.error("BluetoothRequest", "Error in link version response.")
			return nil
		}

		return String(data: data[6 ..< 11], encoding: .utf8)
	}

}
