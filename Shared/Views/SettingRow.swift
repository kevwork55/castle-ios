//
//  SettingRow.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 4/7/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct SettingRow: View {

	let setting: Setting

	var body: some View {
		ZStack {
			// background
			RowBackground()
			// content
			HStack {
				Text(setting.title)
					.font(.system(size: 12, weight: .semibold))
					.foregroundColor(Color("TextPrimary"))
					.allowsTightening(true)
				Spacer()
			}
			.padding(12)
		}
		.frame(height: 52)
	}

}

struct SettingRow_Previews: PreviewProvider {
	static var previews: some View {
		SettingRow(setting: Setting.preview)
			.previewLayout(.sizeThatFits)
	}
}
