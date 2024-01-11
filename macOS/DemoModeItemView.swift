//
//  DemoModeItemView.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 6/17/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct DemoModeItemView: View {

	let controller: MainViewController
	let item: ConnectHelp

	// MARK: -

	var body: some View {
		if let product = item.product,
		   let settingGroup = item.settingGroup {
			Button() {
				controller.showControllerSettings(product: product, settingGroup: settingGroup)
			} label: {
				Text(item.deviceName)
					.font(.system(size: 12, weight: .semibold))
					.foregroundColor(Color("TextPrimary"))
			}
			.buttonStyle(.borderless)
		} else {
			// non-active items
			Text(item.deviceName)
				.font(.system(size: 12, weight: .semibold))
				.foregroundColor(Color("TextPrimaryDisabled"))
		}
	}

}
