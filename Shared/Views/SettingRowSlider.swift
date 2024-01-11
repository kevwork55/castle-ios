//
//  SettingRowSlider.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 5/11/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct SettingRowSlider: View {

	let setting: SettingLinearSpinner
	@ObservedObject var settingValue: SettingValue

	// MARK: -

	var body: some View {
		let range = (setting.minimum ?? 0)...(setting.maximum ?? 10)
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
				Text(settingValue.sliderDisplayString)
					.font(.system(size: 12, weight: .semibold))
					.foregroundColor(Color("TextPrimary"))
				Spacer()
					.frame(width: 8)
				CastleSlider(value: $settingValue.sliderValue, range: range)
					.frame(width: 190)
			}
			.padding(12)
		}
		.frame(height: 52)
	}

}

struct SettingRowSlider_Previews: PreviewProvider {
	static var previews: some View {
		let setting = Setting.previewSlider
		let settingValue = SettingValue(setting)!
		SettingRowSlider(setting: setting, settingValue: settingValue)
			.previewLayout(.sizeThatFits)
	}
}
