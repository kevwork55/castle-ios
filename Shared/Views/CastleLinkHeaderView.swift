//
//  CastleLinkHeaderView.swift
//  CastleLink
//
//  Created by Volodymyr Shevchyk on 15.07.2022.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct CastleLinkHeaderView: View {
    let title: String
    
    var body: some View {
        ZStack() {
            VStack(alignment: .center, spacing: 0) {
                Image("CastleLogoBigLight")
                    .frame(height: 160)
                    .blendMode(.softLight)
                Text(title)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
                    .frame(maxHeight: 32)
            }
        }
    }
}

struct CastleLinkHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        CastleLinkHeaderView(title: "Some title").previewLayout(.sizeThatFits).background(Color("BackgroundDark"))
    }
}
