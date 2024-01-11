//
//  ControllerView.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 6/7/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct ControllerView: View {

	@ObservedObject var device: BluetoothDevice
	@State private var openSettings = false
	@State private var showPasscodeSheet = false
	@State private var signalTimer: Timer?

	// MARK: -

	var body: some View {
		let padding: CGFloat = 8

		ZStack(alignment: .top) {
			Color("ViewBackground")
				.edgesIgnoringSafeArea(.all)
			VStack(alignment: .leading) {
				// device details
				Text("Product: \(device.name)")
					.font(.system(size: 18, weight: .bold))
					.foregroundColor(Color("TextPrimary"))
					.padding(padding)
				Text("Signal strength: \(Int(device.rssi))")
					.font(.system(size: 16, weight: .semibold))
					.foregroundColor(Color("TextPrimary"))
					.padding(padding)
				Text("Status: \(device.status)")
					.font(.system(size: 16, weight: .semibold))
					.foregroundColor(Color("TextPrimary"))
					.padding(padding)
				Text("Firmware: \(device.esc?.firmware.displayVersion ?? "")")
					.font(.system(size: 16, weight: .semibold))
					.foregroundColor(Color("TextPrimary"))
					.padding(padding)
				Text("Memory loaded: \(device.esc?.settingMemoryLoaded ?? 0) bytes")
					.font(.system(size: 16, weight: .semibold))
					.foregroundColor(Color("TextPrimary"))
					.padding(padding)
				Button {
					// toggle the device connection
					if device.isConnected {
						Bluetooth.shared.disconnect(device)
					} else {
						Bluetooth.shared.connect(device)
					}
				} label: {
					Text(device.isConnected ? "Disconnect" : "Connect")
				}
				.padding(padding)

				// unlocked device options
				if (device.connectionState == .unlocked) {
					Text("Debug")
						.font(.system(size: 18, weight: .bold))
						.foregroundColor(Color("TextPrimary"))
						.padding(padding)
/*
					// get link state button
					Button {
						let request = LinkStateRequest() { result in
							if (result == nil) {
								Debug.error("Get link state error.")
							}
						}
						device.sendRequest(request)
					} label: {
						Text("Get Link State")
					}
					.padding(padding)

					// enable link live button
					Button {
						let request = SetLinkStateRequest(linkState: .rxLinkLive) { result in
							if (result != nil) {
								Debug.log("Enable rx passthru complete.")
							} else {
								Debug.error("Enable rx passthru error.")
							}
						}
						device.sendRequest(request)
					} label: {
						Text("Enable Link Live")
					}
					.padding(padding)

					// disable rx passthru button
					Button {
						let request = SetLinkStateRequest(linkState: .rxNormal) { result in
							if (result != nil) {
								Debug.log("Disable rx passthru complete.")
							} else {
								Debug.error("Disable rx passthru error.")
							}
						}
						device.sendRequest(request)
					} label: {
						Text("Disable RX Passthru")
					}
					.padding(padding)

					// hot reset button
					Button {
						let request = SetLinkStateRequest(linkState: .hotReset) { result in
							if (result != nil) {
								Debug.log("Hot reset complete.")
							} else {
								Debug.error("Hot reset error.")
							}
						}
						device.sendRequest(request)
					} label: {
						Text("Hot Reset")
					}
					.padding(padding)

					// set the passcode button
					Button {
						let request = SetPasscodeRequest(passcode: [4, 3, 2, 1]) { result in
							if (result != nil) {
								Debug.log("Passcode set complete.")
							} else {
								Debug.error("Passcode set error.")
							}
						}
						device.sendRequest(request)
					} label: {
						Text("Set Passcode")
					}
					.padding(padding)
*/
					// reload settings button
					Button() {
						device.esc?.reloadSettingMemory()
					} label: {
						Text("Reload Settings")
					}
					.padding(padding)

					// configure settings button
					Button() {
						openSettings = true
					} label: {
						Text("Configure Settings")
					}
					.disabled((device.esc?.settingsLoaded ?? false) == false)
					.padding(padding)
				}
			}
			.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
			.padding(20)

			// navigation link to settings
			NavigationLink(isActive: $openSettings, destination: {
				if let product = device.esc?.product,
				   let settingGroup = device.esc?.firmware.settingGroup,
				   let valueSet = device.esc?.copyCurrentValueSet() {
					DemoSettingsView(product: product, settingGroup: settingGroup, valueSet: valueSet)
				}
			}, label: {
				EmptyView()
			})
		}.onAppear() {
			// connect to the device
			if (device.isConnected == false) {
				device.connect()
			}
			startTimer()
		}.onDisappear() {
			self.stopTimer()
			// disconnect the device
			// TODO: move this elsewhere
//			if device.isConnected {
//				device.disconnect()
//			}
		}
#if os(iOS)
		.navigationBarTitleDisplayMode(.inline)
#endif // os(iOS)
		.sheet(isPresented: $device.askForPasscode, content: {
			PasscodeView(passcode: $device.passcode) {
				device.retryPasscode()
			}
		})
	}

	func startTimer() {
		signalTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
			if device.isConnected {
				device.updateRSSI()
			}
		}
	}

	func stopTimer() {
		signalTimer?.invalidate()
		signalTimer = nil
	}

}

//struct ControllerView_Previews: PreviewProvider {
//	static var previews: some View {
//		ControllerView(device: BluetoothDevice.preview)
//	}
//}

