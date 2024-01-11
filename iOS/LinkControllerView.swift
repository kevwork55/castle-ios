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

	// MARK: -

	var body: some View {
		ZStack {
			// background
			Color("ViewBackground")
				.edgesIgnoringSafeArea(.all)
			// content
			if bluetooth.isAvailable || true {
				ScrollView {
					// header
					VStack(alignment: .leading, spacing: 0) {
						Image("CastleLogo")
							.resizable()
							.aspectRatio(contentMode: .fit)
							.foregroundColor(.white)
							.blendMode(.softLight)
						Text("Discovered B•Links".uppercased())
							.fontWeight(.bold)
							.foregroundColor(Color("TableRowHeader"))
							.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
					}
					// device list
					LazyVStack(alignment: .leading, spacing: 0) {
						ForEach($bluetooth.devices) { $device in
							LinkControllerRow(device: device)
						}
					}
				}.onAppear() {
					bluetooth.startScanning()
				}.onDisappear() {
					bluetooth.stopScanning()
				}
			} else {
				// bluetooth unavailable
				ZStack {
					VStack {
						Image("CastleLogo")
							.resizable()
							.aspectRatio(contentMode: .fit)
							.foregroundColor(.white)
							.blendMode(.softLight)
						Spacer()
					}
					Text(bluetooth.status)
						.font(.system(size: 16, weight: .semibold))
						.foregroundColor(Color("TextPrimary"))
				}
			}
		}
		.navigationBarTitleDisplayMode(.inline)
	}

}

struct LinkControllerView_Previews: PreviewProvider {
	static var previews: some View {
		LinkControllerView()
	}
}
