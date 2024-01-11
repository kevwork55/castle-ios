//
//  Firmware.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 4/7/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//
 
import Foundation

final class Firmware {

	// public (read-only)
	public private(set) var active = true
	public private(set) var beta = false
	public private(set) var broken = false
	public private(set) var displayVersion: String?
	public private(set) var production = false
	public private(set) var releaseDate: String?
	public private(set) var resetLink = false
	public private(set) var revisionNotes: String?
	public private(set) var settingGroup: SettingGroup?
	public private(set) var versionID = ""

	// MARK: -

	init?(with dictionary: [String : Any], productData: ProductData) {
		for (key, value) in dictionary {
			switch key.lowercased() {

				case "verid":
					// firmware version id (string)
					if let versionID = value as? String {
						self.versionID = versionID
					} else {
						Debug.log("Firmware", "Invalid version id: '\(value)'")
					}

				case "custver":
					// display string for firmware version (string)
					if let displayVersion = value as? String {
						self.displayVersion = displayVersion
					} else {
						Debug.log("Firmware", "Invalid display version: '\(value)'")
					}

				case "setgrpkey":
					// setting group key (integer)
					if let settingGroupKey = value as? Int {
						if let settingGroup = productData.settingGroups[settingGroupKey] {
							self.settingGroup = settingGroup
						} else {
							Debug.log("Firmware", "Unknown settings group key: '\(value)'")
						}
					} else {
						Debug.log("Firmware", "Invalid settings group key: '\(value)'")
					}

				case "active":
					// active flag (integer)
					if let active = value as? Int {
						self.active = (active != 0)
					} else {
						Debug.log("Firmware", "Invalid active flag: '\(value)'")
					}

				case "beta":
					// beta flag (integer)
					if let beta = value as? Int {
						self.beta = (beta != 0)
					} else {
						Debug.log("Firmware", "Invalid beta flag: '\(value)'")
					}

				case "broken":
					// broken flag (integer)
					if let broken = value as? Int {
						self.broken = (broken != 0)
					} else {
						Debug.log("Firmware", "Invalid broken flag: '\(value)'")
					}

				case "milestone":
					// milestone (integer)
					// Note: This is ignored.
					break

				case "production":
					// product flag (integer)
					if let production = value as? Int {
						self.production = (production != 0)
					} else {
						Debug.log("Firmware", "Invalid production flag: '\(value)'")
					}

				case "reldate":
					// release date (string)
					if let releaseDate = value as? String {
						self.releaseDate = releaseDate
					} else {
						Debug.log("Firmware", "Invalid release date: '\(value)'")
					}

				case "resetlink":
					// reset link flag (integer)
					if let resetLink = value as? Int {
						self.resetLink = (resetLink != 0)
					} else {
						Debug.log("Firmware", "Invalid reset link flag: '\(value)'")
					}

				case "revtext":
					// revision text string index (integer)
					if let stringIndex = value as? Int {
						revisionNotes = productData.localizedString(index: stringIndex)
					} else {
						Debug.log("Firmware", "Invalid revision text string index: '\(value)'")
					}

				default:
					Debug.log("Firmware", "Found unknown key: '\(key)'")

			}
		}
	}

}
