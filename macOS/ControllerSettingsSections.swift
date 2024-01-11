//
//  ControllerSettingsSections.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 6/17/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct ControllerSettingsSections: View {

	let product: Product
	let settingGroup: SettingGroup

	// MARK: -

	var body: some View {
		// header
		ZStack {
			LinearGradient(gradient: Gradient(colors: [ Color("HighlightGradient0"), Color("HighlightGradient1") ]), startPoint: .leading, endPoint: .trailing)
				.edgesIgnoringSafeArea(.all)
			VStack(alignment: .center) {
				Image("ProductHeaderImage")
					.resizable()
					.aspectRatio(contentMode: .fit)
				Text(product.name)
					.font(.system(size: 14, weight: .semibold))
					.foregroundColor(Color("TextProductHeader"))
			}
			.padding(12)
		}
		.frame(height: 117)

		// sections
		ScrollView {
			LazyVStack(alignment: .leading, spacing: 15) {
				if let subgroups = settingGroup.displaySubgroups {
					ForEach(subgroups) { subgroup in
						Text(subgroup.title.uppercased())
							.font(.system(size: 14, weight: .bold))
							.foregroundColor(Color("TextPrimary"))
					}
				}
			}
			.padding(15)
		}
	}

}

struct ControllerSettingsSections_Previews: PreviewProvider {
	static var previews: some View {
		let settingGroup = SettingGroup.preview
		ControllerSettingsSections(product: Product.preview, settingGroup: settingGroup)
	}
}
