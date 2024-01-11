//
//  PasscodeButton.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 6/13/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct PasscodeButton: View {

	let action: () -> Void
	let number: Int
	@Binding var passcode: [Int]

	// MARK: -

	var body: some View {
		Button(action: {
			if (number >= 0) {
				passcode.append(number)
			} else if (number == -1) {
				if (passcode.isEmpty == false) {
					passcode.removeLast()
				}
			} else if (number == -2) {
				passcode.removeAll()
			}
			// check for a complete passcode
			if (passcode.count == 4) {
				action()
			}
		}, label: {
			// draw the label
			if (number >= 0) {
				Text("\(number)")
					.font(.system(size: 30, weight: .bold))
					.foregroundColor(Color("TextPrimary"))
			} else if (number == -1) {
				Image("PasscodeDelete")
					.foregroundColor(Color("TextPrimary"))
			} else if (number == -2) {
				Image("PasscodeClear")
					.foregroundColor(Color("TextPrimary"))
			}
		})
		.buttonStyle(PasscodeButtonStyle())
		.disabled(passcode.count >= 4)
		.frame(minWidth: 30, idealWidth: 60, maxWidth: 100, minHeight: 30, idealHeight: 60, maxHeight: 100)
	}

}

struct PasscodeButtonStyle: ButtonStyle {

	func makeBody(configuration: Self.Configuration) -> some View {
		ZStack(alignment: .center) {
			// background
			Circle()
				.fill(LinearGradient(colors: configuration.isPressed ? [ Color("ButtonGradient1"), Color("ButtonGradient0") ] : [ Color("ButtonGradient0"), Color("ButtonGradient1") ], startPoint: .top, endPoint: .bottom))
			// label
			configuration.label
				.font(.system(size: 30, weight: .bold))
				.foregroundColor(Color("TextPrimary"))
				.padding(8)
		}
	}

}

struct PasscodeButton_Previews: PreviewProvider {
	@State static var passcode = [Int]()
	static var previews: some View {
		HStack {
			PasscodeButton(action: { }, number: 1, passcode: $passcode)
				.previewLayout(.fixed(width: 80, height: 80))
			PasscodeButton(action: { }, number: -1, passcode: $passcode)
				.previewLayout(.fixed(width: 80, height: 80))
		}
	}
}
