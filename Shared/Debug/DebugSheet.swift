//
//  DebugSheet.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 5/26/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

#if DEBUG

import SwiftUI

struct DebugSheet: View {

	let text: String

#if os(macOS)
	@Environment(\.presentationMode) var presentationMode
#endif // os(macOS)

	// MARK: -

	var body: some View {
		VStack {
			// header
			HStack {
				Text("Debug")
					.font(.system(size: 16, weight: .bold))
				Spacer()
#if os(iOS)
				// iOS options
				Button() {
					// copy the text to the clipboard
					UIPasteboard.general.string = text
				} label: {
					Text("Copy")
						.font(.system(size: 14, weight: .bold))
				}
#elseif os(macOS)
				// macOS options
				Button("Copy") {
					// copy the text to the clipboard
					let pasteboard = NSPasteboard.general
					pasteboard.declareTypes([.string], owner: nil)
					pasteboard.setString(text, forType: .string)
				}
				Button("Close") {
					presentationMode.wrappedValue.dismiss()
				}
#endif // os(macOS)
			}

			// scrollable debug text
			ScrollView {
				Text(text)
					.font(.system(size: 9, weight: .regular, design: .monospaced))
					.frame(maxWidth: .infinity, alignment: .leading)
					.multilineTextAlignment(.leading)
			}
		}
		.padding(20)
	}

}

struct DebugSheet_Previews: PreviewProvider {
	static var previews: some View {
		DebugSheet(text: "This is the debug text.")
	}
}

#endif // DEBUG
