//
//  AboutView.swift
//  CastleLink
//
//  Created by Volodymyr Shevchyk on 15.07.2022.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        ZStack() {
            Color("BackgroundDark")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                CastleLinkHeaderView(title: "Enable All Features With an Account")
                
                Spacer()
                
                Text("About view")
                    .font(.title)
                
                Spacer()
                
                CastleLinkFooterView()
            }
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
