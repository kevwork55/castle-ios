//
//  LoadingView.swift
//  CastleLink
//
//  Created by Volodymyr Shevchyk on 19.07.2022.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .blur(radius: 10)
                .ignoresSafeArea()
                .foregroundColor(.black)
                .opacity(0.5)
            
            LoadingSpinner()
                .frame(width: 100, height: 100)
        }.allowsHitTesting(true)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
