//
//  ToolbarView.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 6/16/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct ToolbarView: View {

	var body: some View {
		ZStack(alignment: .center) {
			// background
//			Color("BarGradient0")
			// content
			HStack {
				Text("CastleLink")
					.font(.system(size: 14, weight: .bold))
					.foregroundColor(.white)
				Spacer()
			}
			.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
		}
		.edgesIgnoringSafeArea(.all)
	}

}

struct ToolbarView_Previews: PreviewProvider {
	static var previews: some View {
		ToolbarView()
			.previewLayout(.fixed(width: 400, height: 50))
	}
}
