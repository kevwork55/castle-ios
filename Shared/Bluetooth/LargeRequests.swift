//
//  LargeRequests.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 6/8/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import Foundation

class LargeRequest<T>: BluetoothResponseRequest<T> {

	init(completion: @escaping ((T?) -> Void)) {
		super.init(characteristic: .large, headerSize: 8, dataSize: 128)
		self.completion = completion

		// set the magic value
		data[0] = 0x02
		// reset the data to 0xFF
		for index in headerSize ..< totalSize {
			data[index] = 0xFF
		}
		// set invalid address for safety
		data[1] = 0xFF
	}

}

// MARK: -

final class GetProgramValuesLargeRequest: LargeRequest<GetProgramValuesLargeRequest.Result> {

	struct Result {
		let address: UInt16
		let data: Data
	}

	var address: UInt16
	var length: Int

	init(address: UInt16, length: Int, completion: @escaping ((Result?) -> Void)) {
		// safety check
		if ((address & 0x07) != 0) {
			Debug.error("LargeRequests", "Get program values called with invalid address.")
		}

		// init
		self.address = address
		self.length = length
		super.init(completion: completion)

		// build the request
		let memoryIndex = (address >> 3)
		data[1] = UInt8(memoryIndex & 0xFF)
		data[2] = UInt8((memoryIndex >> 8) & 0xFF)
		data[3] = UInt8(length)
		data[4] = 0x06 // get program values
	}

	override func parseResult(data: Data) -> Result? {
		// safety check the response makes sense
		guard (data[0] == 0x02), (data.count >= 136) else {
			Debug.error("BluetoothRequest", "Error in large get program values response.")
			return nil
		}

		let readData = data.dropFirst(headerSize)
		return Result(address: self.address, data: readData)
	}

}
