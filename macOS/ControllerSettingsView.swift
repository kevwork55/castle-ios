//
//  ControllerSettingsView.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 6/17/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct ControllerSettingsView: View {

	let product: Product
	let settingGroup: SettingGroup
	let valueSet: SettingValueSet

	// MARK: -

	var body: some View {
		GeometryReader { geometry in
			ZStack {
				Color("ViewBackground")
					.edgesIgnoringSafeArea(.all)
				ScrollView {
					LazyVStack(alignment: .leading, spacing: 0) {
						ProductActionRow(product: product, settingGroup: settingGroup, valueSet: valueSet)
						if let subgroups = settingGroup.displaySubgroups {
							ForEach(subgroups) { subgroup in
								SettingRowHeader(title: subgroup.title)
								ForEach(subgroup.displaySettings) { setting in
									rowForSetting(setting, width: geometry.size.width)
								}
							}
						}
					}
				}
			}
		}
	}

	@ViewBuilder
	private func rowForSetting(_ setting: Setting, width: CGFloat) -> some View {
		// get the setting value
		if let settingValue = valueSet.values[setting.key] {
			switch setting.displayType() {
				case .advancedThrottleGroup:
					// TODO: implement this display type
					SettingRow(setting: setting)
				case .cheatActivationRange:
					// TODO: implement this display type
					SettingRow(setting: setting)
				case .checkBitField:
					// TODO: implement this display type
					SettingRow(setting: setting)
				case .checkboxOverlay:
					// TODO: implement this display type
					SettingRow(setting: setting)
				case .comboCheckbox:
					// TODO: implement this display type
					SettingRow(setting: setting)
				case .dataLogEnabled:
					// TODO: implement this display type
					SettingRow(setting: setting)
				case .dynamicCurve:
					// TODO: implement this display type
					SettingRowCurve(setting: setting, width: width)
				case .linearSpinner:
					SettingRowSlider(setting: setting as! SettingLinearSpinner, settingValue: settingValue)
				case .multiRotorEndpoints:
					// TODO: implement this display type
					SettingRow(setting: setting)
				case .readOnlyCheckbox:
					SettingRowSwitch(setting: setting)
				case .simpleCheckbox:
					SettingRowSwitch(setting: setting)
				case .simpleCombo:
					SettingRowCombo(setting: setting, settingValue: settingValue, width: width)
				case .torqueLimit:
					// TODO: implement this display type
					SettingRow(setting: setting)
				case .voltageCutoffGroup:
					// TODO: implement this display type
					SettingRow(setting: setting)
				default:
					SettingRow(setting: setting)
			}
		} else {
			EmptyView()
		}
	}

}

struct ControllerSettingsView_Previews: PreviewProvider {
	static var previews: some View {
		let settingGroup = SettingGroup.preview
		let valueSet = settingGroup.createDefaultValueSet()
		ControllerSettingsView(product: Product.preview, settingGroup: settingGroup, valueSet: valueSet)
	}
}
