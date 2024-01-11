//
//  SettingLinearSpinner.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 5/11/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import Foundation

final class SettingLinearSpinner: Setting {

	// public (read-only)
	public private(set) var decimalDigits = 0
	public private(set) var increment: Double?
	public private(set) var maximum: Double?
	public private(set) var minimum: Double?
	public private(set) var unitOfMeasurement: String?

	// private
	// TODO: these need to be renamed for clarity
	private var displayValueMax: Double?
	private var displayValueMin: Double?
	private var rawValueMax: Int?
	private var rawValueMin: Int?

	// MARK: -

	override init(title: String) {
		super.init(title: title)
	}

	override init?(_ settingKey: String, with dictionary: [String : Any], productData: ProductData) {
		super.init(settingKey, with: dictionary, productData: productData)

		// TODO: calculate the relationship of the display value to the raw value

		// find the option minimum and maximum
		if let options = self.options {
			for option in options {
				if let numericTitle = option.numericTitle {
					displayValueMax = max(displayValueMax ?? numericTitle, numericTitle)
					displayValueMin = min(displayValueMin ?? numericTitle, numericTitle)
					rawValueMax = max(rawValueMax ?? option.value, option.value)
					rawValueMin = min(rawValueMin ?? option.value, option.value)
				}
			}
		}
	}

	override func decodeKey(key: String, value: Any, productData: ProductData) -> Bool {
		// parse the setting dictionary
		switch key {

			case "dec":
				// decimal digits (integer)
				if let decimalDigits = value as? Int {
					self.decimalDigits = decimalDigits
					return true
				}

			case "inc":
				// increment (float)
				if let incrementValue = value as? Double {
					self.increment = incrementValue
					return true
				}

			case "max":
				// maximum value (float)
				if let maximumValue = value as? Double {
					self.maximum = maximumValue
					return true
				}

			case "min":
				// minimum value (float)
				if let minimumValue = value as? Double {
					self.minimum = minimumValue
					return true
				}

			case "uom":
				// unit of measure (string)
				if let unitOfMeasureValue = value as? String {
					self.unitOfMeasurement = unitOfMeasureValue
					return true
				}

			default:
				break
		}

		return super.decodeKey(key: key, value: value, productData: productData)
	}

	// MARK: -

	func displayValue(for rawValue: Int) -> Double {
		guard let displayValueMax = self.displayValueMax,
			  let displayValueMin = self.displayValueMin,
			  let rawValueMax = self.rawValueMax,
			  let rawValueMin = self.rawValueMin else {
			return Double(rawValue)
		}

		// calculate the display value
		let scale = ((Double(rawValue) - Double(rawValueMin)) / Double(rawValueMax - rawValueMin))
		var displayValue = ((scale * (displayValueMax - displayValueMin)) + displayValueMin)

		// clamp the display value
		displayValue = clampDisplayValue(displayValue)

		// TODO: compare to the options to find any matching numeric title

		return displayValue
	}

	func rawValue(for displayValue: Double) -> Int {
		guard let displayValueMax = self.displayValueMax,
			  let displayValueMin = self.displayValueMin,
			  let rawValueMax = self.rawValueMax,
			  let rawValueMin = self.rawValueMin else {
			return Int(displayValue)
		}

		// clamp the display value
		let displayValue = clampDisplayValue(displayValue)

		// calculate the raw value
		let scale = ((displayValue - displayValueMin) / (displayValueMax - displayValueMin))
		let rawValue = Int((scale * (Double(rawValueMax) - Double(rawValueMin))) + Double(rawValueMin))

		return rawValue
	}

	// MARK: - Private

	private func clampDisplayValue(_ displayValue: Double) -> Double {
		var displayValue = displayValue

		// round to the nearest increment
		if let increment = self.increment {
			displayValue = (round(displayValue / increment) * increment)
		}

		// clamp to the minimum and maximum
		if let maximum = self.maximum, (displayValue >= maximum) {
			displayValue = maximum
		}
		if let minimum = self.minimum, (displayValue <= minimum) {
			displayValue = minimum
		}

		return displayValue
	}

}
