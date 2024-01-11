//
//  SettingSubgroup.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 4/6/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import Foundation

final class SettingSubgroup: Identifiable {

	// public (read-only)
	public private(set) var displayIndex = -1
	public private(set) var hidden = false
	public private(set) var settings = [Setting]()
	public private(set) var title = ""

	// MARK: -

	init?(with dictionary: [String : Any], productData: ProductData) {
		// parse the dictionary
		for (key, value) in dictionary {
			switch key.lowercased() {

				case "idx":
					// display index (integer)
					if let displayIndex = value as? Int {
						self.displayIndex = displayIndex
					} else {
						Debug.log("SettingSubgroup", "Invalid display index: '\(value)'")
					}

				case "ttl":
					// title string index (integer)
					if let stringIndex = value as? Int {
						title = productData.localizedString(index: stringIndex)
					} else {
						Debug.log("SettingSubgroup", "Invalid title string index: '\(value)'")
					}

				case "hid":
					// hidden flag (integer)
					if let hidden = value as? Int {
						self.hidden = (hidden != 0)
					} else {
						Debug.log("SettingSubgroup", "Invalid hidden flag: '\(value)'")
					}

				case "sets":
					// settings (dictionary)
					if let settingsDictionary = value as? [String : Any] {
						for (settingKey, settingValue) in settingsDictionary {
							if let settingDictionary = settingValue as? [String : Any],
							   let setting = Setting.create(settingKey, with: settingDictionary, productData: productData) {
								settings.append(setting)
							} else {
								Debug.log("SettingSubgroup", "Error parsing setting.")
							}
						}
					} else {
						Debug.log("SettingSubgroup", "Error parsing settings.")
					}

				default:
					Debug.log("SettingSubgroup", "Found unknown key: '\(key)'")

			}
		}
	}

	// MARK: - Public

	var displaySettings: [Setting] {
		// add visible settings
		var displaySettings = [Setting]()
		for setting in settings {
			if (setting.displayType() != .none) {
				displaySettings.append(setting)
			}
		}
		// sort the settings into display order
		displaySettings.sort(by: { $0.displayIndex < $1.displayIndex })
		return displaySettings
	}

}
