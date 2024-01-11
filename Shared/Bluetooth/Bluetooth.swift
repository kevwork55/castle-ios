//
//  Bluetooth.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 6/1/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import CoreBluetooth
import Foundation

final class Bluetooth: NSObject, ObservableObject {

	// static
	static let blinkDeviceName = "CLBLE"
	static var shared = Bluetooth()

	// public (read-only)
	@Published var devices = [BluetoothDevice]()
	@Published public private(set) var isAvailable = false

	// private
	private let centralManager: CBCentralManager
	private var scanWhenAvailable = false

	// MARK: -

	private override init() {
		// setup the bluetooth central manager
		centralManager = CBCentralManager(delegate: nil, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
		super.init()
		centralManager.delegate = self
	}

	// MARK: - Public

	var status: String {
		switch centralManager.state {
			case .resetting:
				return "Bluetooth is resetting."
			case .unsupported:
				return "Bluetooth is not available on this device."
			case .unauthorized:
				switch CBCentralManager.authorization {
					case .restricted:
						return "Bluetooth requires authorization."
					case .denied:
						return "Bluetooth was not allowed."
					default:
						break
				}
			case .poweredOff:
				return "Bluetooth is turned off."
			case .poweredOn:
				if centralManager.isScanning {
					return "Bluetooth is scanning."
				} else {
					return "Bluetooth is available."
				}
			default:
				break
		}
		return "Bluetooth is not available."
	}

	func startScanning() {
		// set to scan when available
		scanWhenAvailable = true

		// safety check
		guard (centralManager.state == .poweredOn),
			  (centralManager.isScanning == false) else {
			return
		}

		// reset the device list
		devices.removeAll()

		// add any already connected peripherals
		let connectedPeripherals = centralManager.retrieveConnectedPeripherals(withServices: [])
		for peripheral in connectedPeripherals {
			if isCastleDevice(peripheral) {
				addPeripheral(peripheral, rssi: 0.0)
			}
		}

		// start scanning
		centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
	}

	func stopScanning() {
		// stop scanning
		scanWhenAvailable = false

		// safety check
		guard (centralManager.isScanning == true) else {
			return
		}

		// stop scanning
		centralManager.stopScan()
	}

	// MARK: -

	func connect(_ device: BluetoothDevice) {
		// safety check
		let peripheral = device.peripheral
		guard (peripheral.state == .disconnected) else {
			return
		}

		// connect the peripheral
		centralManager.connect(peripheral)

		// update the device connection state
		device.connectionStateChanged()
	}

	func disconnect(_ device: BluetoothDevice) {
		// safety check
		let peripheral = device.peripheral
		guard ((peripheral.state == .connected) || (peripheral.state == .connecting)) else {
			return
		}

		// disconnect the peripheral
		centralManager.cancelPeripheralConnection(peripheral)

		// update the device connection state
		device.connectionStateChanged()
	}

	// MARK: - Private

	private func addPeripheral(_ peripheral: CBPeripheral, rssi: Double, product: Product? = nil) {
		// check if this is a new device
		if let currentDevice = bluetoothDevice(for: peripheral) {
			// update the product for the device
			if let product = product {
				currentDevice.product = product
			}
			// update the signal strength
			currentDevice.rssi = rssi
			return
		}

		// add the device
		let device = BluetoothDevice(peripheral: peripheral, rssi: rssi, product: product)
		devices.append(device)
	}

	private func bluetoothDevice(for peripheral: CBPeripheral) -> BluetoothDevice? {
		// search for the device
		for device in devices {
			if (device.peripheral.identifier == peripheral.identifier) {
				return device
			}
		}
		return nil
	}

	private func isCastleDevice(_ peripheral: CBPeripheral) -> Bool {
		if let deviceName = peripheral.name, (deviceName == Bluetooth.blinkDeviceName) {
			return true
		}
		return false
	}

}

// MARK: - CBCentralManagerDelegate

extension Bluetooth: CBCentralManagerDelegate {

	func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
		// get the device
		guard let device = bluetoothDevice(for: peripheral) else {
			return
		}

		// update the device connection state
		device.connectionStateChanged()
	}

	func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
		// get the device
		guard let device = bluetoothDevice(for: peripheral) else {
			return
		}

		// update the device connection state
		device.connectionStateChanged()
	}

	func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
		// check for the castle b-link
		guard isCastleDevice(peripheral) else {
			return
		}

		// read the manufacturer data
		var product: Product?
		if let manufacturerData = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data, (manufacturerData.count == 14) {
			// get the product from the firmware string
			if let firmware = String(data: manufacturerData[2...4], encoding: .ascii) {
				product = ProductData.shared.productForFirmware(firmware)
			}

//			let hardwareRevision = manufacturerData[5]
//			let uniqueID = manufacturerData[6...9]
		}

		// add the peripheral
		addPeripheral(peripheral, rssi: RSSI.doubleValue, product: product)
	}

	func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
		// get the device
		guard let device = bluetoothDevice(for: peripheral) else {
			return
		}

		// update the device connection state
		device.connectionStateChanged()
	}

	func centralManagerDidUpdateState(_ central: CBCentralManager) {
		switch central.state {
			case .poweredOn:
				isAvailable = true
				if scanWhenAvailable {
					startScanning()
				}
			case .poweredOff:
				isAvailable = false
			case .resetting:
				isAvailable = false
			case .unauthorized:
				isAvailable = false
			case .unsupported:
				isAvailable = false
			default:
				break
		}
	}

}
