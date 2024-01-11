//
//  BluetoothRequest.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 6/6/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import CoreBluetooth
import Foundation


// TEMP: move these to a better place
let inputXorKey: [UInt8] = [ 0x00, 0x73, 0x81, 0xF8, 0x7C, 0x3e, 0x1F, 0xB7 ]
let outputXorKey: [UInt8] = [ 0x00, 0x95, 0xf2, 0x79, 0x84, 0x42, 0x21, 0xA8 ]
let passcodeXorKey: [UInt8] = [ 0x00, 0x65, 0x01, 0x88, 0x1E, 0xA0, 0x5A, 0x2C ]
let blankXorKey: [UInt8] = [ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ]


class BluetoothRequest {

	// public
	let characteristic: BluetoothDevice.Characteristic
	let dataSize: Int
	let headerSize: Int
	let totalSize: Int
	let wantsResponse = true

	var data: Data

	// MARK: -

	init(characteristic: BluetoothDevice.Characteristic, headerSize: Int, dataSize: Int) {
		self.characteristic = characteristic
		self.headerSize = headerSize
		self.dataSize = dataSize
		self.totalSize = (headerSize + dataSize)
		self.data = Data(count: (headerSize + dataSize))
	}

	func completed(with data: Data? = nil) {
		// TEMP: debug logging
		var dataString = "(no data)"
		if let data = data {
			dataString = data.hexString
		}
		Debug.log("Bluetooth", "Received: \(dataString)")
	}

	func failed() {
		// TEMP: debug logging
		Debug.log("Bluetooth", "Request failed.")
	}

}

// MARK: -

class BluetoothResponseRequest<T>: BluetoothRequest {

	var completion: ((T?) -> Void)?

	override func completed(with data: Data? = nil) {
		super.completed(with: data)

		// parse the result
		var result: T?
		if let data = data {
			result = parseResult(data: data)
		}

		// call the completion handler
		completion?(result)
	}

	override func failed() {
		super.failed()
		// call the completion handler
		completion?(nil)
	}

	func parseResult(data: Data) -> T? {
		return nil
	}

}

class BootloaderRequest<T>: BluetoothRequest {

	init() {
		super.init(characteristic: .bootloader, headerSize: 4, dataSize: 4)
	}

}

// MARK: -

class TelemetryRequest<T>: BluetoothRequest {

	init() {
		super.init(characteristic: .telemetry, headerSize: 0, dataSize: 32)
	}

}
