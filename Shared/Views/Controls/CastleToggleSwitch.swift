//
//  CastleToggleSwitch.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 5/16/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct CastleToggleSwitch: ToggleStyle {

	func makeBody(configuration: Self.Configuration) -> some View {
		return ZStack(alignment: configuration.isOn ? .trailing : .leading) {
			Image("SwitchBackgroundOff")
			Image("SwitchBackgroundOn").opacity(configuration.isOn ? 1.0 : 0.0)
			Image("SwitchKnob")
		}
		.onTapGesture {
			withAnimation() {
				configuration.isOn.toggle()
			}
		}
	}

}

struct CastleToggleSwitch_Previews: PreviewProvider {
	@State static var toggle = false
	static var previews: some View {
		Toggle(isOn: $toggle) {
		}
		.toggleStyle(CastleToggleSwitch())
		.previewLayout(.sizeThatFits)
	}
}
