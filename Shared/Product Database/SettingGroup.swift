//
//  SettingGroup.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 4/6/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import Foundation

final class SettingGroup {

	// public (read-only)
	public private(set) var defaults = ""
	public private(set) var subgroups = [SettingSubgroup]()

	// MARK: -

	init() {
	}

	init?(with dictionary: [String : Any], productData: ProductData) {
		for (key, value) in dictionary {
			let key = key.lowercased()

			if (key == "defaults") {
				// save the defaults
				if let defaults = value as? String {
					self.defaults = defaults
				} else {
					Debug.log("SettingGroup", "Invalid defaults: '\(value)'")
				}
			} else if (key.hasPrefix("sg")) {
				// create the setting subgroup
				if let dictionary = value as? [String : Any],
				   let settingSubgroup = SettingSubgroup(with: dictionary, productData: productData) {
					subgroups.append(settingSubgroup)
				} else {
					Debug.log("SettingGroup", "Error creating subgroup.")
				}
			} else {
				Debug.log("SettingGroup", "Found unknown key: '\(key)'")
			}
		}

		// sort the subgroups into display order
		subgroups.sort(by: { $0.displayIndex < $1.displayIndex })
	}

	// MARK: - Public

	func calculateSize(memoryArea: Int) -> Int {
		var endAddress = 0

		// find the last address referenced by the settings
		for subgroup in subgroups {
			for setting in subgroup.settings {
				if (setting.dataSize > 0), (setting.memoryArea == memoryArea) {
					let settingEndAddress = setting.address + setting.dataSize
					if (settingEndAddress > endAddress) {
						endAddress = settingEndAddress
					}
				}
			}
		}

		return endAddress
	}

	func createDefaultValueSet() -> SettingValueSet {
		let valueSet = createValueSet()

		// set to default values
		if let memory = SettingMemory(string: defaults) {
			valueSet.setValues(with: memory)
		} else {
			Debug.log("SettingGroup", "Error creating setting memory.")
		}

		return valueSet
	}

	func createValueSet() -> SettingValueSet {
		let valueSet = SettingValueSet()

		// add the settings from the subgroups
		for subgroup in subgroups {
			for setting in subgroup.settings {
				valueSet.addSetting(setting)
			}
		}

		return valueSet
	}

	var displaySubgroups: [SettingSubgroup] {
		var displaySubgroups = [SettingSubgroup]()
		for subgroup in subgroups {
			if (subgroup.hidden == false),
			   (subgroup.displaySettings.count > 0) {
				displaySubgroups.append(subgroup)
			}
		}
		return displaySubgroups
	}

	// MARK: - Debug

#if DEBUG

	func dumpMemoryMap() -> String {
		// create an array of all the settings
		var settings = [Setting]()
		for subgroup in subgroups {
			for setting in subgroup.settings {
				// TODO: handle other memory areas
				if (setting.dataSize > 0), (setting.memoryArea == 0) {
					settings.append(setting)
				}
			}
		}

		// sort the array by address
		settings.sort(by: { $0.address < $1.address })
		settings.reverse()

		// dump the memory map
		var currentAddress = 0
		var string = ""
		while (settings.isEmpty == false) {
			// get the last setting
			guard let setting = settings.popLast() else {
				continue
			}

			// mark unused memory
			if (currentAddress < setting.address) {
				let unusedSize = (setting.address - currentAddress)
				string += String(format: "0x%04x: [undocumented] (\(unusedSize) \((unusedSize > 1) ? "bytes" : "byte"))\n", currentAddress)
			}

			// mark setting memory
			string += String(format: "0x%04x: \(setting.title) (%d \((setting.dataSize > 1) ? "bytes" : "byte"))\n", setting.address, setting.dataSize)

			// advance
			currentAddress = (setting.address + setting.dataSize)
		}

		return string
	}

#endif // DEBUG

}

// MARK: - Preview Data

extension SettingGroup {

	static var preview: SettingGroup = {
		let settingGroup = SettingGroup()
		return settingGroup
	}()

}
