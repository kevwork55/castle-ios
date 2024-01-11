//
//  LinkControllerRow.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 6/17/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct LinkControllerRow: View {

	@ObservedObject var device: BluetoothDevice
	@Binding var selectedDevice: BluetoothDevice?

	// MARK: -

	var body: some View {
		ZStack {
			// background
			RowBackground()
			// content
			Button() {
				// select the device
				selectedDevice = device
			} label: {
				HStack {
					Text(device.name)
						.font(.system(size: 16, weight: .semibold))
						.foregroundColor(Color("TextPrimary"))
					Spacer()
					Image(signalStrengthImage())
						.foregroundColor(.white)
				}
				.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
			}
			.buttonStyle(.borderless)
		}
		.frame(height: 64)
	}

	// MARK: - Private

	private func signalStrengthImage() -> String {
		var rssi = device.rssi
		// clamp from -100 to -30
		rssi = max(-100, min(-30, rssi))
		// scale to 0.0 to 1.0
		rssi = ((70 + (rssi + 30)) / 70)
		// choose an image 0 to 5
		let imageNumber = Int(round(rssi * 5))
		return "SignalStrength/\(imageNumber)"
	}

}
/*
struct LinkControllerRow_Previews: PreviewProvider {
	static var previews: some View {
		LinkControllerRow()
	}
}
*/
