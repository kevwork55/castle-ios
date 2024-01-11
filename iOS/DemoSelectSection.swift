//
//  DemoSelectSection.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 5/31/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct DemoSelectSection: View {

	let section: ProductData.ConnectHelpSection
	let width: CGFloat

	@State private var isExpanded = false

	// MARK: -

	var body: some View {
		let rowCount = CGFloat((section.items.count + 1) / 2)
		let headerHeight: CGFloat = 162
		let gridHeight: CGFloat = ((rowCount * 17) + (rowCount * 24) + 24)

		GeometryReader { geometry in
			VStack(alignment: .leading, spacing: 0) {
				// header
				Button() {
					// expand / contract on button press
					withAnimation {
						isExpanded.toggle()
					}
				} label: {
					ZStack(alignment: .leading) {
						Image("Category-" + section.category)
							.resizable()
							.aspectRatio(contentMode: .fill)
							.frame(width: width, height: headerHeight)
						VStack(alignment: .leading, spacing: 0) {
							Text(section.title.uppercased())
								.font(.system(size: 40, weight: .bold))
								.foregroundColor(Color.white)
								.shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.65), radius: 3, x: 0, y: 2)
							Text(section.subtitle)
								.font(.system(size: 15, weight: .regular))
								.foregroundColor(Color.white)
								.shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.65), radius: 3, x: 0, y: 2)
						}
						.padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 0))
					}
				}
				.frame(width: width, height: headerHeight)
				.buttonStyle(.borderless)

				// product grid
				if isExpanded {
					ZStack(alignment: .leading) {
						LinearGradient(colors: [Color("SectionGradient0"), Color("SectionGradient1")], startPoint: .top, endPoint: .bottom)
						LazyVGrid(columns: [GridItem(), GridItem()], alignment: .leading, spacing: 0) {
							ForEach(section.items) { item in
								if let product = item.product,
								   let settingGroup = item.settingGroup {
									// actionable item
									NavigationLink {
										// TODO: don't create the value set here
										let valueSet = settingGroup.createDefaultValueSet()
										DemoSettingsView(product: product, settingGroup: settingGroup, valueSet: valueSet)
									} label: {
										Text(item.deviceName)
											.font(.system(size: 14, weight: .semibold))
											.foregroundColor(.white)
											.padding(12)
									}
								} else {
									// non-actionable item
									Text(item.deviceName)
										.font(.system(size: 14, weight: .semibold))
										.foregroundColor(.white)
										.padding(12)
								}
							}
						}
						.padding(12)
					}
					.frame(height: gridHeight)
				}
			}
			Image("Section-Shadow")
				.resizable()
				.frame(width: width, height: 8)
				.offset(x: 0, y: headerHeight)
		}
		.modifier(AnimatedCellHeight(height: isExpanded ? (headerHeight + gridHeight) : headerHeight))
	}

}

struct DemoSelectSection_Previews: PreviewProvider {
	static var previews: some View {
		let section = ProductData.ConnectHelpSection(category: "Surface", title: "Surface", subtitle: "Anything With Wheels", items: [])
		DemoSelectSection(section: section, width: 320)
			.previewLayout(.sizeThatFits)
	}
}
