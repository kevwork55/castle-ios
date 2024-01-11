//
//  ConnectHelp.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 4/7/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import Foundation

final class ConnectHelp: Identifiable {

	// public (read-only)
	public private(set) var demoFirmwareVersion = ""
	public private(set) var deviceName = ""
	public private(set) var firmwareVersions = ""
	public private(set) var mobileEnabled = false

	// public
	var product: Product?
	var settingGroup: SettingGroup?

	// MARK: -

	init() {
	}

	init?(with dictionary: [String : Any], productData: ProductData) {
		for (key, value) in dictionary {
			switch key.lowercased() {

				case "device_name":
					// device display name (string)
					if let deviceName = value as? String {
						self.deviceName = deviceName
					} else {
						Debug.log("ConnectHelp", "Invalid device name: '\(value)'")
					}

				case "ghost_device":
					// firmware version for demo mode (string)
					if let firmwareVersion = value as? String {
						self.demoFirmwareVersion = firmwareVersion
					} else {
						Debug.log("ConnectHelp", "Invalid demo firmware version: '\(value)'")
					}

				case "mobile_enabled":
					// enable on mobile app flag (integer)
					if let mobileEnabled = value as? Int {
						self.mobileEnabled = (mobileEnabled != 0)
					} else {
						Debug.log("ConnectHelp", "Invalid mobile enable flag: '\(value)'")
					}

				case "requires_link_device":
					// requires link device (integer)
					// Note: This is ignored.
					break

				case "version_list":
					// firmware version list (string)
					if let firmwareVersions = value as? String {
						self.firmwareVersions = firmwareVersions
					} else {
						Debug.log("ConnectHelp", "Invalid firmware versions: '\(value)'")
					}

				default:
					Debug.log("ConnectHelp", "Found unknown key: '\(key)'")

			}
		}
	}

}

// MARK: - Preview Data

extension ConnectHelp {

	static var preview: ConnectHelp = {
		let connectHelp = ConnectHelp()
		connectHelp.deviceName = "Rocket Booster 120"
		connectHelp.firmwareVersions = "2.0.1, 2.0, 1.3, 1.2, 1.1, 1.0"
		return connectHelp
	}()

}
