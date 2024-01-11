//
//  RowBackground.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 6/3/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct RowBackground: View {

	var body: some View {
		ZStack(alignment: .bottom) {
			LinearGradient(gradient: Gradient(colors: [ Color("BarGradient0"), Color("BarGradient1") ]), startPoint: .top, endPoint: .bottom)
			Line().frame(height: 0.5)
		}
	}

}

struct RowBackground_Previews: PreviewProvider {
	static var previews: some View {
		RowBackground()
			.previewLayout(.fixed(width: 400, height: 100))
	}
}
