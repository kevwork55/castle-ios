//
//  CastleLinkFooterView.swift
//  CastleLink
//
//  Created by Volodymyr Shevchyk on 15.07.2022.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct CastleLinkFooterView: View {
    let appInfo: AppInfo = AppInfo()
    
    var body: some View {
        ZStack() {
            VStack(alignment: .center, spacing: 0) {
                Image("CastleLinkLogoLight")

                Text("2022 Castle Creations Inc.\nCastle Link for \(appInfo.platform) Version \(appInfo.appVersion)")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 12, weight: .light))
                    .foregroundColor(.white)
            }
        }
    }
}

struct CastleLinkFooterView_Previews: PreviewProvider {
    static var previews: some View {
        CastleLinkFooterView().previewLayout(.sizeThatFits)
            .background(Color("BarGradient0"))
    }
}
