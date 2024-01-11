//
//  SettingRowHeader.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 5/11/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct SettingRowHeader: View {

	let title: String

	var body: some View {
		Text(title.uppercased())
			.fontWeight(.bold)
			.foregroundColor(Color("TableRowHeader"))
			.frame(height: 58, alignment: .bottom)
			.padding(12)
	}

}

struct SettingRowHeader_Previews: PreviewProvider {
	static var previews: some View {
		SettingRowHeader(title: "Setting Header")
			.previewLayout(.sizeThatFits)
	}
}
