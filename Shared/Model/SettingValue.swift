//
//  SettingValue.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 5/24/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

class SettingValue: ObservableObject {

	let setting: Setting
	var data: [UInt8]

	// MARK: -

	init?(_ setting: Setting) {
		// safety check
		guard (setting.address >= 0), (setting.dataType != .none) else {
			Debug.error("SettingValue", "Error reading setting.")
			return nil
		}
		guard (setting.dataSize > 0) else {
			return nil
		}

		self.setting = setting
		self.data = [UInt8](repeating: 0, count: setting.dataSize)

		// set the data to the default option
		var foundDefault = false
		if let options = setting.options {
			// find the default option
			for option in options {
				if option.isDefault {
					self.intValue = option.value
					foundDefault = true
					break
				}
			}
			if (foundDefault == false) {
				// use the first option
				self.intValue = options[0].value
				foundDefault = true
			}
		}

		// use the minmum for linear spinners
		if (foundDefault == false),
		   let setting = setting as? SettingLinearSpinner,
		   let minimum = setting.minimum {
			self.intValue = setting.rawValue(for: minimum)
			foundDefault = true
		}
	}

	// MARK: -

	func read(from memory: SettingMemory) {
		// safety checks
		guard ((setting.address + setting.dataSize) < memory.bytes.count) else {
			Debug.error("SettingValue", "Error reading value from memory.")
			return
		}
		guard (setting.memoryArea == 0) else {
			Debug.error("SettingValue", "Error reading value from memory. (memoryArea != 0)")
			return
		}

		// copy the data
		for count in 0 ..< setting.dataSize {
			data[count] = memory.bytes[setting.address + count]
		}
	}

	func write(to memory: SettingMemory) {
		// safety checks
		guard (setting.dataSize > 0), (setting.memoryArea == 0), (
			(setting.address + setting.dataSize) <= memory.bytes.count) else {
			return
		}

		// copy the data
		for count in 0 ..< setting.dataSize {
			memory.bytes[setting.address + count] = data[count]
		}
	}

	// MARK: -

	var boolValue: Bool {
		get {
			return (data[0] != 0)
		}
		set {
			objectWillChange.send()
			if (data.count > 1) {
				for index in 1 ..< data.count {
					data[index] = 0
				}
			}
			data[0] = newValue ? 1 : 0
		}
	}

	var intValue: Int {
		get {
			var currentValue = 0
			for index in 0 ..< data.count {
				currentValue = (currentValue << 8)
				currentValue = (currentValue | Int(data[index]))
			}
			return currentValue
		}
		set {
			objectWillChange.send()
			var currentValue = newValue
			for index in 0 ..< data.count {
				data[index] = UInt8(currentValue & 0xFF)
				currentValue >>= 8
			}
		}
	}

	var selectedOption: Int {
		get {
			// safety check
			guard let options = setting.options else {
				return 0
			}

			// find the option that matches the value
			let currentValue = self.intValue
			for index in 0 ..< options.count {
				let option = options[index]
				if (option.value == currentValue) {
					return index
				}
			}

			return 0
		}
		set {
			// safety check
			guard let options = setting.options, (newValue < options.count) else {
				return
			}

			self.intValue = options[newValue].value
		}
	}

	var sliderDisplayString: String {
		if let setting = (setting as? SettingLinearSpinner) {
			var valueString = String(format: "%0.\(setting.decimalDigits)f", self.sliderValue)
			if let unitOfMeasurement = setting.unitOfMeasurement {
				valueString += unitOfMeasurement
			}
			return valueString
		}
		return "\(self.intValue)"
	}

	var sliderValue: Double {
		get {
			let setting = self.setting as! SettingLinearSpinner
			return setting.displayValue(for: self.intValue)
		}
		set {
			let setting = self.setting as! SettingLinearSpinner
			self.intValue = setting.rawValue(for: newValue)
		}
	}

}
