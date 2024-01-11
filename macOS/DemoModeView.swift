//
//  DemoModeView.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 6/17/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct DemoModeView: View {

	let controller: MainViewController

	// MARK: -

	var body: some View {
		let productData = ProductData.shared

		ZStack(alignment: .top) {
			// background
			LinearGradient(colors: [Color("PanelBackground1"), Color("PanelBackground0")], startPoint: .top, endPoint: .bottom)
				.edgesIgnoringSafeArea(.all)
			// content
			ScrollView {
				VStack(alignment: .leading, spacing: 0) {
					// product sections
					ForEach(productData.connectHelpSections) { section in
						DemoModeSection(controller: controller, section: section)
					}
				}
			}
		}
	}

}

struct DemoModeView_Previews: PreviewProvider {
	static var previews: some View {
		DemoModeView(controller: MainViewController())
	}
}
