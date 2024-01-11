//
//  SettingRowCurve.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 5/12/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct SettingRowCurve: View {

	var setting: Setting
	let width: CGFloat

	@StateObject private var curve = Curve()
	@State private var isExpanded = false

	var body: some View {
		let curveEditorHeight = CurveEditor.calculateHeight(for: width)

		ZStack {
			// background
			RowBackground()
			// content
			VStack(spacing: 0) {
				// row header
				HStack {
					Text(setting.title)
						.font(.system(size: 12, weight: .semibold))
						.foregroundColor(Color("TextPrimary"))
						.allowsTightening(true)
					Spacer()
					Button(action: {
						// expand / contract on button press
						withAnimation {
							isExpanded.toggle()
						}
					}, label: {
						Image("ButtonCurveEditor").renderingMode(.original)
					})
					.buttonStyle(.borderless)
					.frame(width: 32, height: 32)
				}
				.frame(height: 52)
				// curve editor (when expanded)
				if isExpanded {
					CurveEditor(curve: curve)
				}
			}
			.padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
		}
		.modifier(AnimatedCellHeight(height: isExpanded ? (52 + curveEditorHeight) : 52))
	}

}

struct SettingRowCurve_Previews: PreviewProvider {
	static var previews: some View {
		SettingRowCurve(setting: Setting.previewCurve, width: 400)
			.previewLayout(.fixed(width: 400, height: 600))
	}
}
