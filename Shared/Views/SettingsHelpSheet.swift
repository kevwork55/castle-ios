//
//  SettingsHelpSheet.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 5/24/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct SettingsHelpSheet: View {

	let product: Product

	@Environment(\.presentationMode) var presentationMode

	// MARK: -

	var body: some View {
		ZStack {
			// background
			Color("ViewBackground")
				.edgesIgnoringSafeArea(.all)
			VStack {
				// grab handle
				Capsule(style: .continuous)
					.fill(.black)
					.frame(width: 140, height: 3)
					.opacity(0.9)
					.padding(12)
				// close sheet button
				Button(action: dimissHelpSheet) {
					HStack {
						Image("Gear")
						Text("Settings Descriptions")
							.font(.system(size: 12, weight: .semibold))
							.foregroundColor(Color("TableRowHeader"))
					}
				}
					.buttonStyle(.borderless)
					.padding(8)
				// scrollable help
				ZStack {
					RoundedRectangle(cornerRadius: 4)
						.fill(.black)
						.overlay(
							RoundedRectangle(cornerRadius: 4)
								.fill(LinearGradient(colors: [Color("CurveBackgroundGradient0"), Color("CurveBackgroundGradient1")], startPoint: .top, endPoint: .bottom))
								.padding(EdgeInsets(top: 1, leading: 0.5, bottom: 0, trailing: 0.5))
								.clipShape(RoundedRectangle(cornerRadius: 4))
						)
					ScrollView {
						LazyVStack(alignment: .leading, spacing: 0){
							if let subgroups = product.firmwareVersions.first?.settingGroup?.displaySubgroups {
								ForEach(subgroups) { subgroup in
									ForEach(subgroup.displaySettings) { setting in
										if (setting.help != "") && (setting.help != "na") {
											VStack(alignment: .leading, spacing: 0) {
												Text(setting.title)
													.font(.system(size: 12, weight: .semibold))
													.foregroundColor(Color("TextPrimary"))
													.padding(8)
												Text(setting.help)
													.font(.system(size: 9, weight: .regular))
													.foregroundColor(Color("TextPrimary"))
													.padding(8)
											}
										}
									}
								}
							}
						}
					}
					.background(Color.clear)
					.padding(2)
				}
				.padding(12)
			}
		}
	}

	// MARK: - Private

	private func dimissHelpSheet() {
		presentationMode.wrappedValue.dismiss()
	}

}

struct SettingsHelpSheet_Previews: PreviewProvider {
	static var previews: some View {
		SettingsHelpSheet(product: Product.preview)
	}
}
