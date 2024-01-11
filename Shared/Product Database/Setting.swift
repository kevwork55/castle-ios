//
//  Setting.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 4/6/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import Foundation

class Setting: Identifiable {

	enum SettingType: Int {
		case requiredHidden = 1
		case hidden = 2
		case setValue = 3
		case simpleLabel = 100
		case simpleCheckBox = 101
		case simpleComboBox = 102
		case readOnlyCheckBox = 103
		case simpleGroupBox = 104
		case checkBitField = 105
		case escSoftwareUpdate = 500
		case voltageCutoff = 501
		case dynamicCurve = 502
		case linearSpinner = 503
		case governorGain = 504
		case bergFreq = 505
		case bergControl = 506
		case bergChannelSlider = 507
		case sequentialMemory = 508
		case thunderbirdVoltageCutoff = 509
		case millisecondDisplayLabel = 510
		case loggingDataOperations = 511
		case advancedThrottle = 512
		case fileOperations = 513
		case thunderbirdVoltageCutoff2 = 514
		case loggingDataEnabled = 515
		case cheatActivationRange = 516
		case advancedThrottleLongFormat = 517
		case torqueLimit = 518
		case advancedThrottleLongFormatNewEndpoints = 519
		case alarmPresets = 520
		case alarmTemperature = 521
		case rpmAndPoleCountParent = 522
		case rpmAndPoleCountChild = 523
		case advancedThrottleLongFormatNewEndpointsMultiRotorNoSimple = 524
		case advancedThrottleLongFormatNewEndpointsMultiRotor = 525
		case advancedThrottleLongFormatNewEndpointsMultiRotorExternalGov = 526
		case advancedThrottleLongFormatNewEndpointsMultiRotor2ExternalGov = 527
		case advancedThrottleLongFormatNewEndpointsMultiRotorNoSimpleExternalGov = 528
		case advancedThrottleLongFormatNewEndpointsMultiRotor2NoSimpleExternalGov = 529
		case rx2Mode = 530
		case multiRotorEndpoints = 531
		case dynamicCurve1024 = 532
		case comboCheck = 533
		case loggingDataEnabledV2 = 534
		case dyneticSystem = 1001
		case industrialThrottle = 1002
		case riniControllerRPM = 1050
		case resetLog = 1051
		case onTimeLogOperations = 1052
		case none = 9999
	}

	enum DataType: Int {
		case none = -1
		case byte = 0
		case cInt = 1
		case cLong = 2
		case cFloat = 3
		case multiByte = 100
		case separateBytes = 150
	}

	enum DisplayType {
		case none
		case advancedThrottleGroup
		case cheatActivationRange
		case checkBitField
		case checkboxOverlay
		case comboCheckbox
		case dataLogEnabled
//		case dataLogOperations
		case dynamicCurve
//		case hiddenSetting
		case linearSpinner
//		case millisecondDisplay
		case multiRotorEndpoints
		case readOnlyCheckbox
//		case requiredHidden
//		case setValue
		case simpleCheckbox
		case simpleCombo
		case torqueLimit
		case voltageCutoffGroup
	}

	// public (read-only)
	public private(set) var address = -1
	public private(set) var dataSize = -1	// size in bytes of data
	public private(set) var dataType = DataType.none
	public private(set) var displayIndex = -1
	public private(set) var help = ""
	public private(set) var key = ""
	public private(set) var memoryArea = -1
	public private(set) var options: [SettingOption]?
	public private(set) var title = ""
	public private(set) var type = SettingType.none

	// MARK: -

	static func create(_ key: String, with dictionary: [String : Any], productData: ProductData) -> Setting? {
		// get the setting type
		guard let typeValue = dictionary["Type"] as? Int,
			  let type = SettingType(rawValue: typeValue) else {
			return nil
		}

		if type == .linearSpinner {
			return SettingLinearSpinner(key, with: dictionary, productData: productData)
		}

		return Setting(key, with: dictionary, productData: productData)
	}

	// MARK: -

	init(title: String) {
		self.title = title
	}

	init?(_ settingKey: String, with dictionary: [String : Any], productData: ProductData) {
		self.key = settingKey

		// parse the setting dictionary
		for (key, value) in dictionary {
			if (self.decodeKey(key: key.lowercased(), value: value, productData: productData) == false) {
				Debug.log("Setting", "Found unhandled key: '\(key)'")
			}
		}

		// sort any options into display order
		options?.sort(by: { $0.displayIndex < $1.displayIndex })

		// TODO: validate the setting
	}

	func decodeKey(key: String, value: Any, productData: ProductData) -> Bool {
		switch key {

			case "type":
				// setting type enum (integer)
				if let typeValue = value as? Int,
				   let type = SettingType(rawValue: typeValue) {
					self.type = type
					return true
				}

			case "idx":
				// display index (integer)
				if let displayIndex = value as? Int {
					self.displayIndex = displayIndex
					return true
				}

			case "ttl":
				// title string index (integer)
				if let stringIndex = value as? Int {
					self.title = productData.localizedString(index: stringIndex)
					return true
				}

			case "help":
				// help string index (integer)
				if let stringIndex = value as? Int {
					self.help = productData.localizedString(index: stringIndex)
					return true
				}

			case "add":
				// controller memory address (integer)
				if let address = value as? Int {
					self.address = address
					return true
				}

			case "dsz":
				// data size in bytes (integer)
				if let dataSize = value as? Int {
					self.dataSize = dataSize
					return true
				}

			case "dtyp":
				// data type enum (integer)
				if let dataTypeValue = value as? Int,
				   let dataType = DataType(rawValue: dataTypeValue) {
					self.dataType = dataType
					return true
				}

			case "memarea":
				// controller memory area (integer)
				if let memoryArea = value as? Int {
					self.memoryArea = memoryArea
					return true
				}

			case "opts":
				// options (dictionary)
				if let optionsDictionary = value as? [String : Any] {
					var options = [SettingOption]()
					for (_, optionValue) in optionsDictionary {
						if let optionDictionary = optionValue as? [String : Any],
						   let option = SettingOption(with: optionDictionary, productData: productData) {
							options.append(option)
						} else {
							Debug.log("Setting", "Error parsing option.")
						}
					}
					if (options.isEmpty == false) {
						self.options = options
					}
					return true
				} else {
					Debug.log("Setting", "Error parsing options.")
				}

			// TODO: implement these setting properties

			case "clock_freq":
				return true
			case "datalog_freq":
				return true
			case "divider":
				return true
			case "arm_count_default":
				return true
			case "arm_count_max":
				return true
			case "arm_count_min":
				return true
			case "max_count_default":
				return true
			case "max_count_max":
				return true
			case "max_count_min":
				return true
			case "spooled_up":
				return true
			case "spool_up":
				return true
			case "governor_gain":
				return true
			case "throttle_response":
				return true
			case "warns":
				return true

			default:
				break
		}

		return false
	}

	func displayType() -> DisplayType {
		switch (type) {
			case .advancedThrottle, .advancedThrottleLongFormat, .advancedThrottleLongFormatNewEndpoints, .advancedThrottleLongFormatNewEndpointsMultiRotor, .advancedThrottleLongFormatNewEndpointsMultiRotor2ExternalGov, .advancedThrottleLongFormatNewEndpointsMultiRotor2NoSimpleExternalGov, .advancedThrottleLongFormatNewEndpointsMultiRotorExternalGov, .advancedThrottleLongFormatNewEndpointsMultiRotorNoSimple, .advancedThrottleLongFormatNewEndpointsMultiRotorNoSimpleExternalGov:
				return .advancedThrottleGroup
			case .cheatActivationRange:
				return .cheatActivationRange
			case .checkBitField:
				return .checkBitField
			case .comboCheck:
				return .comboCheckbox
			case .dynamicCurve, .dynamicCurve1024:
				return .dynamicCurve
//			case .fileOperations:
//				return .hiddenSetting
//			case .hidden:
//				return .hiddenSetting
			case .linearSpinner:
				return .linearSpinner
			case .loggingDataEnabled, .loggingDataEnabledV2:
				return .dataLogEnabled
//			case .loggingDataOperations:
//				return .dataLogOperations
//			case .millisecondDisplayLabel:
//				return .millisecondDisplay
			case .multiRotorEndpoints:
				return .multiRotorEndpoints
			case .readOnlyCheckBox:
				return .readOnlyCheckbox
//			case .requiredHidden:
//				return .requiredHidden
			case .rx2Mode:
				return .checkboxOverlay
//			case .setValue:
//				return .setValue
			case .simpleCheckBox:
				return .simpleCheckbox
			case .simpleComboBox:
				return .simpleCombo
			case .torqueLimit:
				return .torqueLimit
			case .voltageCutoff:
				return .voltageCutoffGroup
			default:
				return .none
		}
	}

}

// MARK: - Preview Data

extension Setting {

	static var preview: Setting = {
		var setting = Setting(title: "Cutoff Voltage")
		return setting
	}()

	static var previewCombo: Setting = {
		var setting = Setting(title: "Direction")
		setting.options = [
			SettingOption(title: "Reverse"),
			SettingOption(title: "Forward")
		]
		return setting
	}()

	static var previewCurve: Setting = {
		var setting = Setting(title: "Throttle Curve")
		return setting
	}()

	static var previewSlider: SettingLinearSpinner = {
		var setting = SettingLinearSpinner(title: "Brake Amount")
		setting.type = .linearSpinner
		setting.options = [
			SettingOption(title: "Reverse"),
			SettingOption(title: "Forward")
		]
		return setting
	}()

	static var previewToggle: Setting = {
		var setting = Setting(title: "Power-On Warning Beep")
		return setting
	}()

}
