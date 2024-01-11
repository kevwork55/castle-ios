//
//  SettingValueSet.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 5/24/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

class SettingValueSet {

	public private(set) var settings = [Setting]()
	public private(set) var values = [String : SettingValue]()

	// MARK: -

	func addSetting(_ setting: Setting) {
		// safety check
		guard setting.key.isEmpty == false else {
			return
		}

		// create the setting value
		if let settingValue = SettingValue(setting) {
			settings.append(setting)
			values[setting.key] = settingValue
		}
	}

	func settingMemory() -> SettingMemory? {
		// calculate the required memory size for the settings
		var memorySize = 0
		for setting in settings {
			// TODO: implement these setting types
			if ((setting.type == .loggingDataEnabledV2) || (setting.type == .dynamicCurve1024)) {
				continue
			}
			if ((setting.dataSize > 0) && (setting.memoryArea == 0)) {
				let settingEndAddress = (setting.address + setting.dataSize)
				if (settingEndAddress > memorySize) {
					memorySize = settingEndAddress
				}
			}
		}

		// create the memory
		guard (memorySize > 0), let memory = SettingMemory(size: memorySize) else {
			return nil
		}

		// write the settings to setting memory
		for (_, value) in values {
			value.write(to: memory)
		}

		return memory
	}

	func setValues(with memory: SettingMemory) {
		// read the values from setting memory
		for (_, value) in values {
			value.read(from: memory)
		}
	}

	// MARK: - Debug

#if DEBUG

	func dump() -> String {
		let sortedSettings = settings.sorted(by: { $0.address < $1.address } )
		var string = ""

		for setting in sortedSettings {
			if let settingValue = values[setting.key] {
				let intValue = settingValue.intValue
				string += ("'\(setting.title)': \(intValue) (\(String(format: "0x%x", intValue)))\n")
			}
		}
		return string
	}

#endif // DEBUG

}
