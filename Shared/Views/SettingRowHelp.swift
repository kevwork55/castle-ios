//
//  SettingRowHelp.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 5/17/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct SettingRowHelp: View {

	let product: Product

	@State private var showingHelpSheet = false

	// MARK: -

	var body: some View {
		ZStack {
			Color("ViewBackground")
			Button(action: toggleHelpSheet) {
				HStack {
					Image("Gear")
					Text("Settings Descriptions")
						.font(.system(size: 12, weight: .semibold))
						.foregroundColor(Color("TableRowHeader"))
				}
			}
			.buttonStyle(.borderless)
			.padding(12)
		}
		.sheet(isPresented: $showingHelpSheet, content: sheetContent)
	}

	private func sheetContent() -> some View {
		SettingsHelpSheet(product: product)
	}

	private func toggleHelpSheet() {
		showingHelpSheet = true
	}

}

struct SettingRowHelp_Previews: PreviewProvider {
	static var previews: some View {
		SettingRowHelp(product: Product.preview)
			.previewLayout(.sizeThatFits)
	}
}
