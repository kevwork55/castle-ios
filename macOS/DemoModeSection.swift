//
//  DemoModeSection.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 6/17/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct DemoModeSection: View {

	let controller: MainViewController
	let section: ProductData.ConnectHelpSection

	// MARK: -

	var body: some View {
		let headerHeight: CGFloat = 148

		VStack(alignment: .leading, spacing: 0) {
			// header
			Image("Category-" + section.category)
				.resizable()
				.aspectRatio(contentMode: .fill)
				.frame(maxWidth: .infinity, maxHeight: headerHeight)
				.clipped()
			Image("Section-Shadow")
				.resizable()
				.frame(maxWidth: .infinity, maxHeight: 8)

			// product grid
			HStack(alignment: .top) {
				HStack(spacing: 0) {
					VStack(alignment: .leading, spacing: 0) {
						Text(section.title.uppercased())
							.font(.system(size: 26, weight: .bold))
							.foregroundColor(Color.white)
							.shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.65), radius: 3, x: 0, y: 2)
						Text(section.subtitle)
							.font(.system(size: 15, weight: .regular))
							.foregroundColor(Color.white)
							.shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.65), radius: 3, x: 0, y: 2)
					}
					Spacer()
				}
				.frame(minWidth: 220, idealWidth: 220, maxWidth: 220)

				VStack(alignment: .leading, spacing: 10) {
					ForEach(itemsForColumn(0)) { item in
						DemoModeItemView(controller: controller, item: item)
					}
				}

				VStack(alignment: .leading, spacing: 10) {
					ForEach(itemsForColumn(1)) { item in
						DemoModeItemView(controller: controller, item: item)
					}
				}

				VStack(alignment: .leading, spacing: 10) {
					ForEach(itemsForColumn(2)) { item in
						DemoModeItemView(controller: controller, item: item)
					}
				}
			}
			.padding(EdgeInsets(top: 16, leading: 24, bottom: 24, trailing: 24))
		}
	}

	// MARK: - Private

	private func itemsForColumn(_ column: Int) -> [ConnectHelp] {
		var items = [ConnectHelp]()
		for index in 0 ..< section.items.count {
			if ((index % 3) == column) {
				items.append(section.items[index])
			}
		}
		return items
	}

}

struct DemoModeSection_Previews: PreviewProvider {
	static var previews: some View {
		let section = ProductData.ConnectHelpSection(category: "Surface", title: "Surface", subtitle: "Anything With Wheels", items: [])
		DemoModeSection(controller: MainViewController(), section: section)
			.previewLayout(.fixed(width: 600, height: 400))
	}
}
