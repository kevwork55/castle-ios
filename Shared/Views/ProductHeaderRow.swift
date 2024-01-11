//
//  ProductHeaderRow.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 5/12/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct ProductHeaderRow: View {

	let product: Product

	var body: some View {
		ZStack {
			LinearGradient(gradient: Gradient(colors: [ Color("HighlightGradient0"), Color("HighlightGradient1") ]), startPoint: .leading, endPoint: .trailing)
				.edgesIgnoringSafeArea(.all)
			VStack(alignment: .center) {
				Image("ProductHeaderImage")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(height: 117)
				Text(product.name)
					.font(.system(size: 18, weight: .semibold))
					.foregroundColor(Color("TextProductHeader"))
			}
			.padding(12)
		}
	}

}

struct ProductHeaderRow_Previews: PreviewProvider {
	static var previews: some View {
		ProductHeaderRow(product: Product.preview)
			.previewLayout(.sizeThatFits)
	}
}
