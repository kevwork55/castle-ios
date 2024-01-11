//
//  MultiLang.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 4/7/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import Foundation

final class MultiLang {

	// public (read-only)
	public private(set) var stringsByID = [String : String]()
	public private(set) var stringsByKey = [Int : String]()

	// MARK: -

	init?(with dictionary: [String : Any]) {
		// parse the entries
		for (_, value) in dictionary {
			if let entryDictionary = value as? [String : Any],
			   let entryKey = entryDictionary["Key"] as? Int,
			   let entryString = entryDictionary["en"] as? String {
				stringsByKey[entryKey] = entryString
				if let entryID = entryDictionary["ID"] as? String {
					stringsByID[entryID] = entryString
				}
			} else {
				Debug.log("MultiLang", "Error parsing entry.")
			}
		}
	}

}
