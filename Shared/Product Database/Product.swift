//
//  Product.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 4/7/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import Foundation

final class Product {

	// public (read-only)
	public private(set) var firmwareVersions = [Firmware]()
	public private(set) var maxVolt: Double?
	public private(set) var minVolt: Double?
	public private(set) var mobileEnabled = false
	public private(set) var name = ""
	public private(set) var productClass = ""

	// MARK: -

	init() {
	}

	init?(with dictionary: [String : Any], productData: ProductData) {
		for (key, value) in dictionary {
			switch key.lowercased() {

				case "name":
					// product name (string)
					if let name = value as? String {
						self.name = name
					} else {
						Debug.log("Product", "Invalid product name: '\(value)'")
					}

				case "productclass":
					// product class (string)
					if let productClass = value as? String {
						self.productClass = productClass
					} else {
						Debug.log("Product", "Invalid product class: '\(value)'")
					}

				case "maxvolt":
					// maximum voltage for the product (double)
					if let maxVolt = value as? Double {
						self.maxVolt = maxVolt
					} else {
						Debug.log("Product", "Invalid maximum voltage: '\(value)'")
					}

				case "minvolt":
					// minimum voltage for the product (double)
					if let minVolt = value as? Double {
						self.minVolt = minVolt
					} else {
						Debug.log("Product", "Invalid minimum voltage: '\(value)'")
					}

				case "mobile_enabled":
					// enable on mobile app flag (integer)
					if let mobileEnabled = value as? Int {
						self.mobileEnabled = (mobileEnabled != 0)
					} else {
						Debug.log("Product", "Invalid mobile enable flag: '\(value)'")
					}

				case "software":
					// firmware versions (dictionary)
					if let firmwareDictionaries = value as? [String : Any] {
						for (_, firmwareValue) in firmwareDictionaries {
							if let firmwareDictionary = firmwareValue as? [String : Any],
							   let firmware = Firmware(with: firmwareDictionary, productData: productData) {
								firmwareVersions.append(firmware)
							} else {
								Debug.log("Product", "Error parsing firmware.")
							}
						}
					} else {
						Debug.log("Product", "Error parsing firmware versions.")
					}

				default:
					Debug.log("Product", "Found unknown key: '\(key)'")

			}
		}
	}

	func firmware(with versionID: String) -> Firmware? {
		// find the firmware by version id
		for firmware in firmwareVersions {
			if (firmware.versionID == versionID) {
				return firmware
			}
		}
		return nil
	}

}

// MARK: - Preview Data

extension Product {

	static var preview: Product = {
		let product = Product()
		product.name = "Gizmo 100"
		return product
	}()

}
