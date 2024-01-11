//
//  BluetoothDevice.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 6/1/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import CoreBluetooth
import Foundation

final class BluetoothDevice: NSObject, CBPeripheralDelegate, Identifiable, ObservableObject {

	// bluetooth service uuids
	enum Service: String {

		case bootloader = "00060000-F8CE-11E4-ABF4-0002A5D5C51B"
		case castleLink = "38D65BE5-BF52-48B7-BFE9-66D70E059BD9"

		var uuid: CBUUID {
			CBUUID(string: self.rawValue)
		}

	}

	// service characteristic uuids
	enum Characteristic: String {

		// bootloader service characteristics
		case bootloader = "00060001-F8CE-11E4-ABF4-0002A5D5C51B"

		// castlelink service characteristics
		case classic = "E1140890-6F23-4ED2-A1D7-A7059A6037D1"
		case control = "78724345-AAB0-4C9D-886A-EAD107238900"
		case large = "94FDC469-0526-4516-8049-4EE1A3F469D6"
		case telemetry = "52D0A085-B00F-4424-89F7-F8B24EFB1634"

		var uuid: CBUUID {
			CBUUID(string: self.rawValue)
		}

	}

	enum ConnectionState {
		case fatalError
		case disconnected
		case disconnecting
		case connected
		case connecting
		case unknown
		case locked
		case unlocked
	}

	// MARK: -

	// public (read-only)
	let id: UUID
	let peripheral: CBPeripheral
	public private(set) var isPrepared = false
	public private(set) var passcodeFailed = false
	public private(set) var setupControllerFailed = false

	// published
	@Published var askForPasscode = false
	@Published var connectionState = ConnectionState.disconnected
	@Published var esc: ESC?
	@Published var name: String = ""
	@Published var passcode = [1, 2, 3, 4]
	@Published var rssi: Double = 0.0 // range: -99 to -30
	@Published var status: String = ""

	// public
	var product: Product? {
		didSet {
			// update the display name
			updateName()
		}
	}

	// private
	private var activeRequest: BluetoothRequest?
	private var characteristics = [CBCharacteristic]()
	private var pendingRequests = [BluetoothRequest]()

	// MARK: -

	init(peripheral: CBPeripheral, rssi: Double, product: Product? = nil) {
		self.id = peripheral.identifier
		self.peripheral = peripheral
		self.product = product
		self.rssi = rssi

		super.init()

		peripheral.delegate = self
		updateName()
		updateStatus()
	}

	// MARK: -

	func connect() {
		Bluetooth.shared.connect(self)
	}

	func disconnect() {
		Bluetooth.shared.connect(self)
	}

	var isConnected: Bool {
		return (peripheral.state == .connected)
	}

	var isSafeForWriting: Bool {
		// safety check the signal strength
		return (rssi >= -50.0)
	}

	func sendRequest(_ request: BluetoothRequest) {
		if (activeRequest == nil) {
			// start the request
			_ = startRequest(request)
		} else {
			// add the request to the queue
			pendingRequests.append(request)
		}
	}

	// MARK: -

	func connectionStateChanged() {
		// update the connection state
		updateConnectionState(linkState: nil, lockState: nil)
		// update the initial device setup when first connected
		if (peripheral.state == .connected) {
			updateDeviceSetup()
		}
	}

	func retryPasscode() {
		passcodeFailed = false
		updateDeviceSetup()
	}

	func updateName() {
		if let productName = product?.name {
			name = productName
		} else if (peripheral.name == Bluetooth.blinkDeviceName) {
			name = "Castle B•LINK"
		} else {
			name = "Unknown"
		}
	}

	func updateRSSI() {
		peripheral.readRSSI()
	}

	func updateStatus() {
		// update the status with the connection state
		switch connectionState {
			case .fatalError:
				status = "Connection Error"
			case .disconnected:
				status = "Disconnected"
			case .disconnecting:
				status = "Disconnecting"
			case .connected:
				status = "Connected"
			case .connecting:
				status = "Connecting"
			case .locked:
				status = "Connected (Locked)"
			case .unlocked:
				status = "Connected (Unlocked)"
			default:
				status = "Unknown"
		}
	}

	// MARK: - Private

	private func characteristic(for type: Characteristic) -> CBCharacteristic? {
		// search for the characteristic by uuid
		let uuid = type.uuid
		for characteristic in characteristics {
			if (characteristic.uuid == uuid) {
				return characteristic
			}
		}

		return nil
	}

	private func fatalConnectionError() {
		connectionState = .fatalError
		if (peripheral.state == .connected) {
			// disconnect on a fatal error
			Bluetooth.shared.disconnect(self)
		}
		updateStatus()
	}

	private func requestCompleted(success: Bool, data: Data? = nil) {
		// complete the active request
		if let request = activeRequest {
			if success {
				request.completed(with: data)
			} else {
				request.failed()
			}
		}

		// clear the active request
		activeRequest = nil

		// start the next request
		while let nextRequest = pendingRequests.first {
			// remove the request from the queue
			pendingRequests.remove(at: 0)
			// attempt to start the request
			if (startRequest(nextRequest) == true) {
				return
			}
		}
	}

	private func startRequest(_ request: BluetoothRequest) -> Bool {
		// safety check
		guard (activeRequest == nil), (request.data.count > 0) else {
			Debug.error("BluetoothDevice", "Error starting request.")
			request.failed()
			return false
		}

		// get the characteristic
		guard let characteristic = characteristic(for: request.characteristic) else {
			Debug.error("BluetoothDevice", "Error finding characteristic for request.")
			request.failed()
			return false
		}

		// set the request as the active request
		activeRequest = request

		// write the value
		peripheral.writeValue(request.data, for: characteristic, type: .withResponse)

		// TEMP: debug logging
		Debug.log("Bluetooth", "Sending: \(request.data.hexString)")

		return true
	}

	private func updateDeviceSetup() {
		// safety check
		guard (connectionState != .fatalError) else {
			return
		}

		// check the device is still connected
		guard (peripheral.state == .connected) else {
			connectionState = .unknown
			isPrepared = false
			return
		}

		if (isPrepared == false) {
			// prepare the characteristics
			peripheral.discoverServices(nil)
		} else if (connectionState == .connected) {
			// request the link state to get the lock state
			sendRequest(LinkStateRequest() { result in
				guard let result = result else {
					return
				}

				// update the connection state
				self.updateConnectionState(linkState: result.linkState, lockState: result.lockState)
				self.updateDeviceSetup()
			})
		} else if (connectionState == .locked) {
			if (passcodeFailed == false) {
				// send the passcode to unlock
				setupSendPasscode()
			}
		} else if (connectionState == .unlocked) {
			if (esc == nil), (setupControllerFailed == false) {
				setupRequestESCFirmwareVersion()
			}
		}
	}

	private func updateConnectionState(linkState: UInt8?, lockState: UInt8?) {
		if let linkState = linkState, let lockState = lockState,
		   (peripheral.state == .connected) {
			if (linkState == 0x01) {
				if (lockState == 0x00) {
					connectionState = .locked
				} else if (lockState == 0x01) {
					connectionState = .unlocked
				} else {
					connectionState = .unknown
				}
			} else {
				connectionState = .unknown
			}
		} else {
			switch peripheral.state {
				case .connected:
					connectionState = .connected
				case .connecting:
					connectionState = .connecting
				case .disconnected:
					connectionState = .disconnected
				case .disconnecting:
					connectionState = .disconnecting
				default:
					connectionState = .unknown
			}
		}

		updateStatus()
	}

	// MARK: -

	private func setupSendPasscode() {
		// request to unlock
		sendRequest(PasscodeChallengeRequest() { result in
			// safety check
			guard let result = result else {
				return
			}

			// send the challenge answer
			self.sendRequest(PasscodeAnswerRequest(passcode: self.passcode, challenge: result.challenge) { result in
				// safety check
				guard let result = result else {
					return
				}

				// update the connection state with the result
				self.updateConnectionState(linkState: result.linkState, lockState: result.lockState)
				self.passcodeFailed = (self.connectionState != .unlocked)
				self.updateDeviceSetup()

				// mark if we need to ask for the passcode
				if (self.passcodeFailed) && (self.passcode == [1, 2, 3, 4]) {
					self.passcode = []
					self.askForPasscode = true
				}
			})
		})
	}

	private func setupRequestESCFirmwareVersion() {
		// request the esc firmware version
		sendRequest(BootloaderVersionRequest() { result in
			// safety check
			guard let versionID = result else {
				return
			}

			// save the firmware version
			let productID = String(versionID.dropLast(4))
			if let product = ProductData.shared.productForFirmware(productID),
			   let firmware = product.firmware(with: versionID) {
				// setup the esc
				let esc = ESC(device: self, product: product, firmware: firmware)
				// load the esc settings
				esc.reloadSettingMemory()
				self.esc = esc
			}
		})
	}

	// MARK: - CBPeripheralDelegate

	func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
		// safety check
		guard let characteristics = service.characteristics, (characteristics.count > 0) else {
			Debug.error("BluetoothDevice", "Error discovering characteristics. (\(error?.localizedDescription ?? "no error"))")
			fatalConnectionError()
			return
		}

		// save the characteristics
		self.characteristics = characteristics
		isPrepared = true

		// continue device setup
		updateDeviceSetup()
	}

	func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
		// safety check
		guard let services = peripheral.services, (services.count > 0) else {
			Debug.error("BluetoothDevice", "Error discovering services. (\(error?.localizedDescription ?? "no error"))")
			fatalConnectionError()
			return
		}

		// prepare the characteristics
		for service in services {
			if (service.uuid == Service.castleLink.uuid) {
				peripheral.discoverCharacteristics(nil, for: service)
			}
		}
	}

	func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
		// safety check
		guard error == nil else {
			rssi = 0.0
			return
		}

		rssi = RSSI.doubleValue
	}

	func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
		// check for any bluetooth error
		if let error = error {
			Debug.error("BluetoothDevice", "Error reading value from characteristic. (\(error.localizedDescription))")
			requestCompleted(success: false)
			return
		}

		// check the active request
		guard let request = activeRequest, (request.characteristic.uuid == characteristic.uuid) else {
			Debug.error("BluetoothDevice", "Error reading value. (Invalid active request.)")
			requestCompleted(success: false)
			return
		}

		// request completed
		requestCompleted(success: true, data: characteristic.value)
	}

	func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
		// check for any error
		if let error = error {
			Debug.error("BluetoothDevice", "Error writing value to characteristic. (\(error.localizedDescription))")
			requestCompleted(success: false)
			return
		}

		// check the active request
		guard let request = activeRequest, (request.characteristic.uuid == characteristic.uuid) else {
			Debug.error("BluetoothDevice", "Error writing value. (Invalid active request.)")
			requestCompleted(success: false)
			return
		}

		// check if the request needs a response
		if request.wantsResponse {
			// read the response
			peripheral.readValue(for: characteristic)
		} else {
			// request is complete
			requestCompleted(success: true)
		}
	}

}
