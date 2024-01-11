//
//  ESC.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 6/9/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import Foundation

final class ESC: ObservableObject {

	// public (read-only)
	let device: BluetoothDevice
	let product: Product
	let firmware: Firmware

	// published
	@Published var settingMemory: SettingMemory?
	@Published var settingMemoryFailed = false
	@Published var settingMemoryLoaded = 0
	@Published var settingsLoaded = false

	// private
	private var settingMemoryRequests = 0
	private var settingsLoading = false

	// MARK: -

	init(device: BluetoothDevice, product: Product, firmware: Firmware) {
		self.device = device
		self.product = product
		self.firmware = firmware
	}

	// MARK: -

	func copyCurrentValueSet() -> SettingValueSet? {
		// get the setting group for the firmware
		guard let settingGroup = firmware.settingGroup else {
			return nil
		}

		// create a value set from the setting group
		let valueSet = settingGroup.createValueSet()
		// copy the values from setting memory
		if let settingMemory = self.settingMemory {
			valueSet.setValues(with: settingMemory)
		}

		return valueSet
	}

	func reloadSettingMemory() {
		// get the setting group
		guard let settingGroup = firmware.settingGroup,
			  (settingsLoading == false) else {
			return
		}

		// TODO: this should check if loading the memory is already in progress

		// reset the loaded memory
		settingMemory = nil
		settingMemoryFailed = false
		settingMemoryLoaded = 0
		settingsLoading = true

		// calculate the size of setting memory
		let memoryAreaSize = UInt16(settingGroup.calculateSize(memoryArea: 0))
		settingMemory = SettingMemory(size: Int(memoryAreaSize))

		// load memory area 0 (large requests)
		var currentAddress: UInt16 = 0
		while (currentAddress < memoryAreaSize) {
			let readSize = min((memoryAreaSize - currentAddress), 128)
			device.sendRequest(GetProgramValuesLargeRequest(address: currentAddress, length: Int(readSize), completion: memoryReadLarge))
			currentAddress += readSize
			settingMemoryRequests += 1
		}
/*
		// load memory area 0 (classic requests)
		let memoryAreaSize = UInt16(settingGroup.calculateSize(memoryArea: 0))
		var currentAddress: UInt16 = 0
		while (currentAddress < memoryAreaSize) {
			device.sendRequest(GetProgramValuesRequest(address: currentAddress, completion: memoryRead))
			currentAddress += 8
			settingMemoryRequests += 1
		}
*/
	}

	// MARK: -

	private func memoryRead(_ result: GetProgramValuesRequest.Result?) {
		// safety check
		if let result = result,
		   let settingMemory = self.settingMemory,
		   ((Int(result.address) + result.data.count) <= settingMemory.bytes.count) {
			// copy the data to setting memory
			let startIndex = Int(result.address)
			let endIndex = (startIndex + result.data.count)
			settingMemory.bytes.replaceSubrange(startIndex ..< endIndex, with: result.data)
			settingMemoryLoaded += result.data.count
		} else {
			// error
			Debug.error("ESC", "Error copying setting memory.")
			settingMemoryFailed = true
		}

		settingMemoryRequests -= 1
		updateMemoryLoad()

		// TEMP
		device.objectWillChange.send()
	}

	private func memoryReadLarge(_ result: GetProgramValuesLargeRequest.Result?) {
		// safety check
		if let result = result,
		   let settingMemory = self.settingMemory,
		   ((Int(result.address) + result.data.count) <= settingMemory.bytes.count) {
			// copy the data to setting memory
			let startIndex = Int(result.address)
			let endIndex = (startIndex + result.data.count)
			settingMemory.bytes.replaceSubrange(startIndex ..< endIndex, with: result.data)
			settingMemoryLoaded += result.data.count
		} else {
			// error
			Debug.error("ESC", "Error copying setting memory.")
			settingMemoryFailed = true
		}

		settingMemoryRequests -= 1
		updateMemoryLoad()

		// TEMP
		device.objectWillChange.send()
	}

	private func updateMemoryLoad() {
		// update the loading status
		if (settingMemoryRequests == 0) {
			Debug.log("ESC", "Loading settings memory complete.")
			// TODO: use a better test for if the settings have loaded
			if (settingMemoryLoaded > 0) {
				settingsLoaded = true
			}
			settingsLoading = false
		}
	}

}
