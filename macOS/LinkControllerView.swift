//
//  LinkControllerView.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 6/1/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct LinkControllerView: View {

	@ObservedObject var bluetooth = Bluetooth.shared

	@State private var selectedDevice: BluetoothDevice?
	@State private var signalTimer: Timer?

	// MARK: -

	var body: some View {
		DetailTwoPaneView(pane1: {
			// bluetooth device list
			VStack {
				// content
				if bluetooth.isAvailable {
					ScrollView {
						// device list
						LazyVStack(alignment: .leading, spacing: 0) {
							ForEach($bluetooth.devices) { $device in
								LinkControllerRow(device: device, selectedDevice: $selectedDevice)
									.buttonStyle(.borderless)
							}
						}
					}.onAppear() {
						bluetooth.startScanning()
					}.onDisappear() {
						bluetooth.stopScanning()
					}
				} else {
					// bluetooth unavailable
					Spacer()
					Text(bluetooth.status)
						.font(.system(size: 16, weight: .semibold))
						.foregroundColor(Color("TextPrimary"))
					Spacer()
				}
			}
		}, pane2: {
			// selected device
			if let selectedDevice = selectedDevice {
				ControllerView(device: selectedDevice)
			}
		})
	}

}

struct LinkControllerView_Previews: PreviewProvider {
	static var previews: some View {
		LinkControllerView()
	}
}
