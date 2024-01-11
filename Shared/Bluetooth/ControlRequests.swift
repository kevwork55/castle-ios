//
//  ControlRequests.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 6/7/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import Foundation

class ControlRequest<T>: BluetoothResponseRequest<T> {

	init(completion: @escaping ((T?) -> Void)) {
		super.init(characteristic: .control, headerSize: 1, dataSize: 7)
		self.completion = completion
	}

	// MARK: -

	fileprivate func encodePasscode(_ passcode: [Int]) -> [UInt8] {
		// safety check
		guard (passcode.count >= 4) else {
			return [UInt8]()
		}

		let d1 = ((passcode[0] + 0x57) & 0xFF)
		let d2 = ((passcode[1] + 0xBD) & 0xFF)
		let d3 = ((passcode[2] + 0x61) & 0xFF)
		let d4 = ((passcode[3] + 0x42) & 0xFF)

		var result = [UInt8]()
		result.append(0)
		result.append(~hexJoin(d4 + d1, d3 ^ d2))
		result.append( hexJoin(d1 + d2, d4 ^ d3))
		result.append( hexJoin(d4 ^ d3, d2 + d1))
		result.append( hexJoin(d3 + d1, d2 + d4))
		result.append( hexJoin(d1 + d4, d3 + d4))
		result.append(~hexJoin(d1 ^ d2, d3 ^ d4))
		result.append( hexJoin(d3 + d4, d1 + d2))

		return result
	}

	fileprivate func hexJoin(_ a: Int, _ b: Int) -> UInt8 {
		return UInt8((((a & 0xFF) << 4) + (b & 0xFF)) & 0xFF)
	}

	fileprivate func xorData(_ data: Data, with xorArray: [UInt8]) -> Data {
		var newData = data
		for index in 0 ..< xorArray.count {
			newData[index] = (xorArray[index] ^ newData[index])
		}
		return newData
	}

}

// MARK: -

final class LinkStateRequest: ControlRequest<LinkStateRequest.Result> {

	struct Result {
		let linkState: UInt8
		let lockState: UInt8
		let rxLinkLive: Bool
	}

	override init(completion: @escaping ((Result?) -> Void)) {
		super.init(completion: completion)
		// build the link state request
		data[0] = 0xF0
	}

	override func parseResult(data: Data) -> LinkStateRequest.Result? {
		// safety check the response makes sense
		guard (data[0] == 0xF0), (data.count >= 8) else {
			Debug.error("BluetoothRequest", "Error in link state response.")
			return nil
		}

		let linkState = (data[1] & 0x7F)
		let rxLinkLive = ((data[1] & 0x80) != 0)

		return Result(linkState: linkState, lockState: data[2], rxLinkLive: rxLinkLive)
	}

}

// MARK: -

final class PasscodeChallengeRequest: ControlRequest<PasscodeChallengeRequest.Result> {

	struct Result {
		let challenge: [UInt8]
	}

	override init(completion: @escaping ((Result?) -> Void)) {
		super.init(completion: completion)
		// build the request
		data[0] = 0xF3
		data = xorData(data, with: outputXorKey)
	}

	override func parseResult(data: Data) -> Result? {
		// safety check the response makes sense
		guard (data[0] == 0xF3), (data.count >= 8) else {
			Debug.error("BluetoothRequest", "Error in passcode challenge response.")
			return nil
		}

		// xor the challenge data
		var challenge = [UInt8]()
		for index in 1 ..< inputXorKey.count {
			challenge.append(inputXorKey[index] ^ data[index])
		}

		return Result(challenge: challenge)
	}

}

// MARK: -

final class PasscodeAnswerRequest: ControlRequest<PasscodeAnswerRequest.Result> {

	struct Result {
		let linkState: UInt8
		let lockState: UInt8
	}

	init(passcode: [Int], challenge: [UInt8], completion: @escaping ((Result?) -> Void)) {
		super.init(completion: completion)

		// build the request
		data[0] = 0xF4

		let passcodeData = encodePasscode(passcode)
		for index in 1 ..< 8 {
			data[index] = UInt8((Int(challenge[index - 1]) + Int(passcodeXorKey[index]) ^ Int(passcodeData[index])) & 0xFF)
		}

		data = xorData(data, with: outputXorKey)
	}

	override func parseResult(data: Data) -> Result? {
		// safety check the response makes sense
		guard (data[0] == 0xF0), (data.count >= 8) else {
			Debug.error("BluetoothRequest", "Error in passcode answer response.")
			return nil
		}

		return Result(linkState: data[1], lockState: data[2])
	}

}

// MARK: -

final class SetPasscodeRequest: ControlRequest<SetPasscodeRequest.Result> {

	struct Result {
		let success: Bool
	}

	init(passcode: [Int], completion: @escaping ((Result?) -> Void)) {
		super.init(completion: completion)

		// build the request
		data[0] = 0xF5
		let passcodeData = encodePasscode(passcode)
		for index in 1 ..< 8 {
			data[index] = passcodeData[index]
		}
		data = xorData(data, with: passcodeXorKey)
	}

	override func parseResult(data: Data) -> Result? {
		// safety check the response makes sense
		guard (data[0] == 0xF5), (data.count >= 8) else {
			Debug.error("BluetoothRequest", "Error in set passcode response.")
			return nil
		}

		return Result(success: true)
	}

}

// MARK: -

final class SetLinkStateRequest: ControlRequest<SetLinkStateRequest.Result> {

	enum LinkState: UInt8 {
		case connecting = 0x00
		case established = 0x01
		case hotReset = 0x40
		case rxNormal = 0x80
		case rxLinkLive = 0x81
		case error = 0xFF
	}

	struct Result {
		let success: Bool
	}

	init(linkState: LinkState, completion: @escaping ((Result?) -> Void)) {
		super.init(completion: completion)

		// build the request
		data[0] = 0xF7
		data[1] = linkState.rawValue
	}

	override func parseResult(data: Data) -> Result? {
		// safety check the response makes sense
		guard (data[0] == 0xF0), (data.count >= 8) else {
			Debug.error("BluetoothRequest", "Error in set link state response.")
			return nil
		}

		return Result(success: true)
	}

}
