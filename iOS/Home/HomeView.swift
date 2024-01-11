//
//  HomeView.swift
//  CastleLink (iOS)
//
//  Created by Volodymyr Shevchyk on 22.07.2022.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        ZStack() {
            Color("BackgroundDark")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                CastleLinkHeaderView(title: "Enable All Features With an Account")
                
                Spacer()
                
                Text("Home view")
                    .font(.title)
                
                GeometryReader { geometry in
                    Button("Sign Out") {
                        self.onSignOutPressed()
                    }
                    .font(.system(size: 24, weight: .semibold))
                    .buttonStyle(CastleFixedButtonStyle(isHighlighted: true, width: geometry.size.width))
                }
                
                Spacer()
                
                CastleLinkFooterView()
            }
        }.navigationBarHidden(true)
    }
    
    private func onSignOutPressed() {
        try? Auth.auth().signOut()
        self.userData.isSignedIn = false
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
