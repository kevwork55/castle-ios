//
//  SettingOption.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 4/6/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import Foundation

final class SettingOption: Identifiable {

	// public (read-only)
	public private(set) var disable = false
	public private(set) var disablesSettings: [String]?
	public private(set) var displayIndex = -1
	public private(set) var help = ""
	public private(set) var isDefault = false
	public private(set) var numericTitle: Double?
	public private(set) var title = ""
	public private(set) var value = -1

	// MARK: -

	init(title: String) {
		self.title = title
	}

	init?(with dictionary: [String : Any], productData: ProductData) {
		for (key, value) in dictionary {
			switch key.lowercased() {

				case "idx":
					// sort index (integer)
					if let index = value as? Int {
						self.displayIndex = index
					} else {
						Debug.log("SettingOption", "Invalid sort index: '\(value)'")
					}

				case "def":
					// default flag (integer)
					if let defaultValue = value as? Int {
						isDefault = (defaultValue != 0)
					} else {
						Debug.log("SettingOption", "Invalid default flag: '\(value)'")
					}

				case "dis":
					// disable flag (integer)
					if let disable = value as? Int {
						self.disable = (disable != 0)
					} else {
						Debug.log("SettingOption", "Invalid disable flag: '\(value)'")
					}

				case "val":
					// option value (integer)
					if let optionValue = value as? Int {
						self.value = optionValue
					} else {
						Debug.log("SettingOption", "Invalid value: '\(value)'")
					}

				case "ttl":
					// title string index (integer)
					if let stringIndex = value as? Int {
						title = productData.localizedString(index: stringIndex)
					} else {
						Debug.log("SettingOption", "Invalid title string index: '\(value)'")
					}

				case "hlp":
					// help string index (integer)
					if let stringIndex = value as? Int {
						help = productData.localizedString(index: stringIndex)
					} else {
						Debug.log("SettingOption", "Invalid help string index: '\(value)'")
					}

				case "nmttl":
					// numeric title (float)
					if let numericTitle = value as? Double {
						self.numericTitle = numericTitle
					} else {
						Debug.log("SettingOption", "Invalid numeric title: '\(value)'")
					}

				case "dsbls":
					// disables (dictionary)
					if let disablesDictionary = value as? [String : Any] {
						decodeDisables(disablesDictionary)
					} else {
						Debug.log("SettingOption", "Error parsing disables.")
					}

				default:
					Debug.log("SettingOption", "Found unknown key: '\(key)'")

			}

			// TODO: validate the setting option
		}
	}

	private func decodeDisables(_ dictionary: [String : Any]) {
		var disablesSettings = [String]()
		for (_, disableValue) in dictionary {
			// parse the disable dictionary
			if let disableDictionary = disableValue as? [String : Any] {
				var disableSettingKey: String?
				for (key, value) in disableDictionary {
					switch key.lowercased() {
						case "dis":
							if let number = value as? Int,
							   (number == 1) {
							} else {
								Debug.log("SettingDisable", "Unknown disable flag: '\(value)'")
							}
						case "type":
							if let number = value as? Int,
							   (number == 0) {
							} else {
								Debug.log("SettingDisable", "Unknown type flag: '\(value)'")
							}
						case "skey":
							if let string = value as? String {
								disableSettingKey = string
							} else {
								Debug.log("SettingOption", "Error parsing disable setting key: '\(value)'")
							}
						default:
							Debug.log("SettingDisable", "Found unknown key: '\(key)'")
					}
				}
				if let disableSettingKey = disableSettingKey {
					disablesSettings.append(disableSettingKey)
				}
			} else {
				Debug.log("SettingOption", "Error parsing disable dictionary.")
			}
		}
		if (disablesSettings.isEmpty == false) {
			self.disablesSettings = disablesSettings
		}
	}

}
