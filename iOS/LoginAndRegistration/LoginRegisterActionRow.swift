//
//  LoginRegisterActionRow.swift
//  CastleLink
//
//  Created by Volodymyr Shevchyk on 15.07.2022.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct LoginRegisterActionRow: View {
    @Binding var selectedMode: Int
    
    let onQuickLink: () -> Void
    
    var body: some View {
        HStack {
            CastleSegmentSelector<Int>(options: [
                .init(title: "Login", value: 0),
                .init(title: "Register", value: 1)
            ], selection: $selectedMode, segmentWidth: 86)
            
            Spacer()
            
            NavigationLink(destination: LinkControllerView()) {
                HStack(alignment: .center, spacing: 10) {
                    Image("FlashLight")
                        
                    Text("Quick Link")
                        .foregroundColor(.white)
                }
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            }
            .buttonStyle(CastleButtonStyle(style: .gradient))
        }
    }
}

struct LoginRegisterActionRow_Previews: PreviewProvider {
    @State static var selectedMode: Int = 0
    
    static var previews: some View {
        LoginRegisterActionRow(selectedMode: $selectedMode) {
            print("")
        }
        .previewLayout(.sizeThatFits)
        .background(Color("BarGradient0"))
    }
}
