//
//  ProductActionRow.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 5/12/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct ProductActionRow: View {

	let product: Product
	let settingGroup: SettingGroup
	let valueSet: SettingValueSet

	@State private var settingsLocked = false
#if DEBUG
	@State private var showingDebugSheet = false
#endif // DEBUG

	// MARK: -

	var body: some View {
		ZStack {
			Color("ViewBackground")
			HStack {
				// settings lock
				Button(action: {
					withAnimation {
						settingsLocked.toggle()
					}
				}, label: {
					HStack(spacing: 2) {
						Text("Save Settings")
							.font(.system(size: 9, weight: .light))
							.foregroundColor(Color("TextPrimary"))
							.opacity(settingsLocked ? 1.0 : 0.65)
						Image(settingsLocked ? "PadlockLocked" : "PadlockUnlocked")
							.opacity(settingsLocked ? 1.0 : 0.65)
					}
				})
				.buttonStyle(.borderless)
				Spacer()
				// send to device
				Text("Send to Device")
					.font(.system(size: 9, weight: .light))
					.foregroundColor(Color("TextPrimary"))
				Button() {
#if DEBUG
					showingDebugSheet = true
#endif // DEBUG
				} label: {
					Image("ButtonSend")
				}
				.buttonStyle(.borderless)
				.frame(width: 80, height: 39)
			}
			.padding(12)
#if DEBUG
			.sheet(isPresented: $showingDebugSheet) {
				DebugSheet(text: debugText())
			}
#endif // DEBUG
		}
	}

	// MARK: - Debug

#if DEBUG

	private func debugText() -> String {
		var string = ""
		string += "Default settings:\n"
		string += "\(settingGroup.defaults)\n"
		let memory = valueSet.settingMemory()
		string += "\n"
		string += "Current settings:\n"
		string += "\(memory?.hexString ?? "error")\n"
		string += "\n"
		string += "Current values:\n"
		string += valueSet.dump().indent()
		string += "\n"
		string += "Memory map:\n"
		string += settingGroup.dumpMemoryMap().indent()
		return string
	}

#endif // DEBUG

}

struct ProductActionRow_Previews: PreviewProvider {
	static var previews: some View {
		let settingGroup = SettingGroup.preview
		let valueSet = settingGroup.createDefaultValueSet()
		ProductActionRow(product: Product.preview, settingGroup: settingGroup, valueSet: valueSet)
			.previewLayout(.sizeThatFits)
	}
}
