//
//  SettingRowCombo.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 5/11/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct SettingRowCombo: View {

	let setting: Setting
	@ObservedObject var settingValue: SettingValue
	let width: CGFloat

	@State private var isExpanded = false

	// MARK: -

	var body: some View {
		let sidePadding: CGFloat = 12
		let options = controlOptions()
		let gridHeight = CastleSegmentedGrid.height(for: options, in: (width - (sidePadding * 2)))
		let segmentSelectorWidth = CastleSegmentSelector.calculateWidth(for: options)
		let showGrid = (segmentSelectorWidth > (width / 2))

		ZStack {
			// background
			RowBackground()
			// content
			VStack(spacing: 0) {
				// row header
				HStack(spacing: 0) {
					Text(setting.title)
						.font(.system(size: 12, weight: .semibold))
						.foregroundColor(Color("TextPrimary"))
						.allowsTightening(true)
					Spacer()
					if (showGrid == false) {
						CastleSegmentSelector(options: options, selection: $settingValue.selectedOption)
					} else {
						// expandable
						Button(options[settingValue.selectedOption].title) {
							// expand / contract on button press
							withAnimation {
								isExpanded.toggle()
							}
						}
						.buttonStyle(CastleButtonStyle(style: isExpanded ? .gradient : .highlighted))
					}
				}
				.frame(height: 52)
				// segment grid (when expanded)
				if isExpanded {
					CastleSegmentedGrid(options: options, selection: $settingValue.selectedOption)
					.frame(height: gridHeight)
					.padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
				}
			}
			.padding(EdgeInsets(top: 0, leading: sidePadding, bottom: 0, trailing: sidePadding))
		}
		.modifier(AnimatedCellHeight(height: isExpanded ? (52 + 8 + gridHeight) : 52))
	}

	private func controlOptions() -> [CastleSegmentSelector<Int>.Option] {
		var controlOptions = [CastleSegmentSelector<Int>.Option]()
		if let options = setting.options {
			for index in 0 ..< options.count {
				let controlOption = CastleSegmentSelector<Int>.Option(title: options[index].title, value: index)
				controlOptions.append(controlOption)
			}
		}
		return controlOptions
	}

}

struct SettingRowCombo_Previews: PreviewProvider {
	static var previews: some View {
		let setting = Setting.previewCombo
		let settingValue = SettingValue(setting)!
		SettingRowCombo(setting: setting, settingValue: settingValue, width: 400)
			.previewLayout(.fixed(width: 400, height: 100))
	}
}
