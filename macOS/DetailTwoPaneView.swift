//
//  DetailTwoPaneView.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 6/17/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct DetailTwoPaneView<Pane1Content: View, Pane2Content: View>: View {

	let pane1: Pane1Content
	let pane2: Pane2Content

	// MARK: -

	var body: some View {
		ZStack {
			// background
			LinearGradient(colors: [Color("PanelBackground0"), Color("PanelBackground1")], startPoint: .bottom, endPoint: .top)
				.edgesIgnoringSafeArea(.all)

			HStack(spacing: 0) {
				// pane 1
				VStack {
					pane1
				}
				.frame(minWidth: 234, idealWidth: 234, maxWidth: 234)
				.background(VStack(spacing: 0) {
					LinearGradient(colors: [Color("BarGradient0"), Color("BarGradient1")], startPoint: .top, endPoint: .bottom)
					Line().frame(height: 1)
				})
				.padding(20)

				// pane 2
				VStack {
					pane2
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity)
			}
		}
	}

	init(@ViewBuilder pane1: () -> Pane1Content, @ViewBuilder pane2: () -> Pane2Content) {
		self.pane1 = pane1()
		self.pane2 = pane2()
	}

}

struct DetailTwoPaneView_Previews: PreviewProvider {
	static var previews: some View {
		DetailTwoPaneView(pane1: {
			Spacer()
			Text("Pane 1")
				.font(.system(size: 16, weight: .semibold))
				.foregroundColor(Color("TextPrimary"))
			Spacer()
		}, pane2: {
			Spacer()
			Text("Pane 2")
				.font(.system(size: 16, weight: .semibold))
				.foregroundColor(Color("TextPrimary"))
			Spacer()
		})
		.previewLayout(.fixed(width: 600, height: 400))
	}
}
