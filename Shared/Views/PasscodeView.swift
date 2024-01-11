//
//  PasscodeView.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 6/13/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct PasscodeView: View {

	@Binding var passcode: [Int]
	let action: () -> Void

	@Environment(\.presentationMode) var presentationMode

	// MARK: -

	var body: some View {
		ZStack {
			Color("ViewBackground")
			VStack(alignment: .center, spacing: 12) {
				Image("CastleLogo")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.foregroundColor(.white)
					.blendMode(.softLight)
				VStack {
					Text("ENTER PASSCODE")
						.font(.system(size: 18, weight: .bold))
						.foregroundColor(Color("AccentColor"))
					HStack(alignment: .center, spacing: 12) {
						Circle()
							.fill((passcode.count >= 1) ? Color("AccentColor") : Color("PasscodeDot"))
							.frame(width: 19, height: 19)
						Circle()
							.fill((passcode.count >= 2) ? Color("AccentColor") : Color("PasscodeDot"))
							.frame(width: 19, height: 19)
						Circle()
							.fill((passcode.count >= 3) ? Color("AccentColor") : Color("PasscodeDot"))
							.frame(width: 19, height: 19)
						Circle()
							.fill((passcode.count >= 4) ? Color("AccentColor") : Color("PasscodeDot"))
							.frame(width: 19, height: 19)
					}
				}
				.padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
				HStack(alignment: .center, spacing: 12) {
					PasscodeButton(action: passcodeComplete, number: 1, passcode: $passcode)
					PasscodeButton(action: passcodeComplete, number: 2, passcode: $passcode)
					PasscodeButton(action: passcodeComplete, number: 3, passcode: $passcode)
				}
				HStack(alignment: .center, spacing: 12) {
					PasscodeButton(action: passcodeComplete, number: 4, passcode: $passcode)
					PasscodeButton(action: passcodeComplete, number: 5, passcode: $passcode)
					PasscodeButton(action: passcodeComplete, number: 6, passcode: $passcode)
				}
				HStack(alignment: .center, spacing: 12) {
					PasscodeButton(action: passcodeComplete, number: 7, passcode: $passcode)
					PasscodeButton(action: passcodeComplete, number: 8, passcode: $passcode)
					PasscodeButton(action: passcodeComplete, number: 6, passcode: $passcode)
				}
				HStack(alignment: .center, spacing: 12) {
					PasscodeButton(action: passcodeComplete, number: -2, passcode: $passcode)
					PasscodeButton(action: passcodeComplete, number: 0, passcode: $passcode)
					PasscodeButton(action: passcodeComplete, number: -1, passcode: $passcode)
				}
				Spacer()
				Text("Forgot Passcode?")
					.font(.system(size: 14, weight: .regular))
					.foregroundColor(Color("TextPrimary"))
				Spacer()
			}
		}
	}

	// MARK: -

	private func passcodeComplete() {
		presentationMode.wrappedValue.dismiss()
		action()
	}

}

struct PasscodeView_Previews: PreviewProvider {
	@State static var passcode = [Int]()
	static var previews: some View {
		PasscodeView(passcode: $passcode, action: { })
			.previewLayout(.sizeThatFits)
	}
}
