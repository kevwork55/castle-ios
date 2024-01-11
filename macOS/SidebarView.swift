//
//  SidebarView.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 6/16/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct SidebarView: View {

	static var versionString: String = {
		var string = ""
		// create the version string
		if let info = Bundle.main.infoDictionary,
		   let marketingVersion = info["CFBundleShortVersionString"] as? String {
			string = "Castle Link for macOS Version \(marketingVersion)"
			// add the build version
			if let buildVersion = info["CFBundleVersion"] as? String {
				string += " (\(buildVersion))"
			}
		}
		return string
	}()

	let controller: MainViewController

	// MARK: -

	var body: some View {
		ZStack(alignment: .top) {
			// background
			HStack(spacing: 0) {
				LinearGradient(colors: [Color("PanelBackground0"), Color("PanelBackground1")], startPoint: .top, endPoint: .bottom)
				Line()
					.frame(width: 1)
			}
			.edgesIgnoringSafeArea(.all)


			// content
			VStack(alignment: .leading) {

				// header
				VStack(alignment: .center, spacing: 0) {
					Image("CastleLogo")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.foregroundColor(.white)
						.blendMode(.softLight)
					Text(SidebarView.versionString)
						.font(.system(size: 10, weight: .light))
						.foregroundColor(Color("TextSecondary"))
					Spacer()
						.frame(height: 20)
					Button {
						controller.showLinkController()
					} label: {
						HStack {
							Image("ButtonLink")
								.foregroundColor(.white)
							Text("Link Controller")
								.font(.system(size: 10, weight: .regular))
								.foregroundColor(.white)
						}
					}
					.buttonStyle(CastleButtonStyle(style: .gradient))
				}
				.frame(maxWidth: .infinity)
				.padding(EdgeInsets(top: 0, leading: 8, bottom: 8, trailing: 8))

				Spacer()

				// footer
				VStack(alignment: .leading, spacing: 0) {
					Button(action: controller.showDemoMode, label: {
						Text("Demo Mode")
					})
					.buttonStyle(SidebarButtonStyle())
					Button(action: showHelp, label: {
						Text("Help")
					})
					.buttonStyle(SidebarButtonStyle())
					Button(action: logout, label: {
						Text("Log Out")
					})
					.buttonStyle(SidebarButtonStyle())
				}
				.padding(EdgeInsets(top: 0, leading: 14, bottom: 14, trailing: 14))
			}
		}
		.frame(minWidth: 224, idealWidth: 224)
	}

	// MARK: -

	private func logout() {
		// TODO: logout
	}

	private func showHelp() {
		// TODO: show help
	}

}

struct SidebarButtonStyle: ButtonStyle {

	func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
			.font(.system(size: 12, weight: .regular))
			.foregroundColor(Color("TextPrimary"))
			.opacity(configuration.isPressed ? 1.0 : 0.5)
			.padding(6)
	}

}

struct SidebarView_Previews: PreviewProvider {
	static var previews: some View {
		SidebarView(controller: MainViewController())
			.previewLayout(.fixed(width: 224, height: 600))
	}
}
