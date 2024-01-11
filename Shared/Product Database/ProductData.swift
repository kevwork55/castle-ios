//
//  ProductData.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 4/5/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

final class ProductData: ObservableObject {

	struct ConnectHelpSection: Identifiable {

		let category: String
		let title: String
		let subtitle: String
		let items: [ConnectHelp]

		var id: String {
			return category
		}

	}

	// static
	static let shared: ProductData = {
		let productDataURL = Bundle.main.url(forResource: "ProductData", withExtension: "cldb")!
		return ProductData(fileURL: productDataURL)!
	}()

	// public (read-only)
	public private(set) var connectHelp = [ConnectHelp]()
	public private(set) var connectHelpSections = [ConnectHelpSection]()
	public private(set) var databaseVersion = 0
	public private(set) var multiLang: MultiLang?
	public private(set) var products = [String : Product]()
	public private(set) var requiredAppVersion: Double?
	public private(set) var settingGroups = [Int : SettingGroup]()

	// private
	private var firmwareLookup: [String : [String : Any]]?

	// MARK: -

	init() {
	}

	init?(fileURL: URL) {
		// load the database file
		guard let data = try? Data(contentsOf: fileURL) else {
			Debug.log("ProductData", "Error loading file.")
			return nil
		}

		// parse the data as json
		guard let jsonObject = try? JSONSerialization.jsonObject(with: data) else {
			Debug.log("ProductData", "Error parsing data.")
			return nil
		}

		// get the root dictionary
		guard let root = jsonObject as? [String : Any] else {
			Debug.log("ProductData", "Error getting root dictionary.")
			return nil
		}

		// parse the database info
		if let databaseInfo = root["DatabaseInfo"] as? [String : Any] {
			if let databaseVersion = databaseInfo["databaseVersion"] as? Int {
				self.databaseVersion = databaseVersion
			} else {
				Debug.log("ProductData", "Invalid database version.")
			}
			if let requiredAppVersion = databaseInfo["requiredAppVersion"] as? Double {
				self.requiredAppVersion = requiredAppVersion
			} else {
				Debug.log("ProductData", "Invalid required app version.")
			}
		} else {
			Debug.log("ProductData", "Error finding database info.")
		}

		// parse the multi-language dictionary
		if let multiLangDictionary = root["MultiLang"] as? [String : Any],
			let multiLang = MultiLang(with: multiLangDictionary) {
			self.multiLang = multiLang
		} else {
			Debug.log("ProductData", "Error parsing multilang.")
		}

		// parse the setting groups
		if let settingGroupsDictionary = root["SettingGroups"] as? [String : Any] {
			for (key, value) in settingGroupsDictionary {
				if let keyInteger = Int(key.dropFirst()),
				   let settingGroupDictionary = value as? [String : Any],
				   let settingGroup = SettingGroup(with: settingGroupDictionary, productData: self) {
					settingGroups[keyInteger] = settingGroup
				} else {
					Debug.log("ProductData", "Error creating setting group.")
				}
			}
		} else {
			Debug.log("ProductData", "Error finding setting groups.")
		}

		// parse the products
		if let productsDictionary = root["Controllers"] as? [String : Any] {
			for (key, value) in productsDictionary {
				if (key.lowercased() != "lookup") {
					if let productDictionary = value as? [String : Any],
					   let product = Product(with: productDictionary, productData: self) {
						products[key] = product
					} else {
						Debug.log("ProductData", "Error creating product.")
					}
				} else {
					// save the demo lookup table
					firmwareLookup = value as? [String : [String : Any]]
				}
			}
		} else {
			Debug.log("ProductData", "Error finding products.")
		}

		// parse the connect help
		if let connectHelpDictionaries = root["ConnectHelp"] as? [String : Any] {
			for (_, value) in connectHelpDictionaries {
				if let connectHelpDictionary = value as? [String : Any],
				   let connectHelp = ConnectHelp(with: connectHelpDictionary, productData: self) {
					self.connectHelp.append(connectHelp)
					if (connectHelp.demoFirmwareVersion.isEmpty == false) {
						if let dictionary = firmwareLookup?[connectHelp.demoFirmwareVersion],
						   let controllerKey = dictionary["CtrlKey"] as? String,
						   let settingGroupKey = dictionary["DemoGrpKey"] as? Int {
							connectHelp.product = products[controllerKey]
							connectHelp.settingGroup = settingGroups[settingGroupKey]
						}
					}
				} else {
					Debug.log("ProductData", "Error creating connect help.")
				}
			}
		} else {
			Debug.log("ProductData", "Error finding connect help.")
		}

		rebuildConnectHelpSections()
	}

	// MARK: - Public

	func localizedString(index: Int) -> String {
		if let string = multiLang?.stringsByKey[index] {
			return string
		}
		return ""
	}

	func productForFirmware(_ firmwareString: String) -> Product? {
		if let dictionary = firmwareLookup?[firmwareString],
		   let controllerKey = dictionary["CtrlKey"] as? String {
			return products[controllerKey]
		}
		return nil
	}

	// MARK: - Private

	private func rebuildConnectHelpSections() {
		// sort the products
		var airProducts = [ConnectHelp]()
		var otherProducts = [ConnectHelp]()
		var surfaceProducts = [ConnectHelp]()

		// TODO: this should use product categories for sorting

		for item in connectHelp {
			let deviceName = item.deviceName.lowercased()
			if (deviceName.contains("mamba") || deviceName.contains("sidewinder") || deviceName.contains("copperhead") || deviceName.contains("cobra")) {
				surfaceProducts.append(item)
			} else if (deviceName.contains("phoenix") || deviceName.contains("talon") || deviceName.contains("multi-rotor") || deviceName.contains("dmr")) {
				airProducts.append(item)
			} else {
				otherProducts.append(item)
			}
		}

		// create the sections
		if (surfaceProducts.count > 0) {
			surfaceProducts.sort(by: { $0.deviceName < $1.deviceName })
			connectHelpSections.append(ConnectHelpSection(category: "Surface", title: "Surface", subtitle: "Anything With Wheels", items: surfaceProducts))
		}
		if (airProducts.count > 0) {
			airProducts.sort(by: { $0.deviceName < $1.deviceName })
			connectHelpSections.append(ConnectHelpSection(category: "Air", title: "Air", subtitle: "Wings or Rotors", items: airProducts))
		}
		if (otherProducts.count > 0) {
			otherProducts.sort(by: { $0.deviceName < $1.deviceName })
			connectHelpSections.append(ConnectHelpSection(category: "Other", title: "Other", subtitle: "Everything Else", items: otherProducts))
		}
	}

}
