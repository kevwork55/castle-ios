//
//  DemoSelectView.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 4/5/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct DemoSelectView: View {

	static var versionString: String = {
		var string = ""
		// create the version string
		if let info = Bundle.main.infoDictionary,
		   let marketingVersion = info["CFBundleShortVersionString"] as? String {
#if os(macOS)
			string = "Castle Link for macOS Version \(marketingVersion)"
#else
			string = "Castle Link for iOS Version \(marketingVersion)"
#endif // os(macOS)
			// add the build version
			if let buildVersion = info["CFBundleVersion"] as? String {
				string += " (\(buildVersion))"
			}
		}
		return string
	}()

	@EnvironmentObject var productData: ProductData

	// MARK: -

	var body: some View {
		GeometryReader { geometry  in
			ZStack {
				Color("ViewBackground")
					.edgesIgnoringSafeArea(.all)
				ScrollView {
					VStack(alignment: .leading, spacing: 0) {
						// header
						VStack(spacing: 8) {
							Image("CastleLogo")
								.resizable()
								.aspectRatio(contentMode: .fit)
								.foregroundColor(.white)
								.blendMode(.softLight)
							Text("With the Castle B-Link you can\nuse your iPhone to easily program your controller")
								.font(.system(size: 9, weight: .regular))
								.foregroundColor(.white)
								.multilineTextAlignment(.center)
							NavigationLink {
								LinkControllerView()
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
						.frame(width: geometry.size.width)
						.padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))

						// product sections
						ForEach(productData.connectHelpSections) { section in
							DemoSelectSection(section: section, width: geometry.size.width)
						}

						// footer
						VStack(spacing: 4) {
							Image("CastleLinkLogo")
								.foregroundColor(Color.white.opacity(0.4))
								.padding(8)
							Text("© 2022 Castle Creations Inc.")
								.font(.system(size: 12, weight: .regular))
								.foregroundColor(Color("TextPrimary"))
							Text(DemoSelectView.versionString)
								.font(.system(size: 12, weight: .regular))
								.foregroundColor(Color("TextPrimary"))
						}
						.frame(width: geometry.size.width)
						.padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
					}
				}
			}
		}
#if os(iOS)
		.navigationBarHidden(true)
#endif // os(iOS)
		.navigationTitle("Products")
	}

}

struct DemoSelectView_Previews: PreviewProvider {
	static var previews: some View {
		DemoSelectView().environmentObject(ProductData())
	}
}
