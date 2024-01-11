//
//  HomeView.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 6/16/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct HomeView: View {

	var body: some View {
		ZStack(alignment: .top) {
			// background
			LinearGradient(colors: [Color("PanelBackground1"), Color("PanelBackground0")], startPoint: .top, endPoint: .bottom)
				.edgesIgnoringSafeArea(.all)
		}
	}

}

struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView()
			.previewLayout(.fixed(width: 400, height: 300))
	}
}
