//
//  SettingRowSwitch.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 5/11/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct SettingRowSwitch: View {

	let setting: Setting

	@State var toggle: Bool = false

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
				Text(toggle ? "Enabled" : "Disabled")
					.font(.system(size: 10, weight: .light))
					.foregroundColor(toggle ? Color("TextPrimary") : Color("TextPrimaryDisabled"))
				Toggle(isOn: $toggle) {
				}
				.toggleStyle(CastleToggleSwitch())
			}
			.padding(12)
		}
		.frame(height: 52)
	}

}

struct SettingRowSwitch_Previews: PreviewProvider {
	static var previews: some View {
		SettingRowSwitch(setting: Setting.previewToggle)
			.previewLayout(.sizeThatFits)
	}
}
