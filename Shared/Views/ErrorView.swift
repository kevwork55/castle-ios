//
//  ErrorView.swift
//  CastleLink (iOS)
//
//  Created by Volodymyr Shevchyk on 22.07.2022.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct ErrorView: View {
    @Binding var errorMessage: String

    var body: some View {
        if self.errorMessage.isEmpty == false {
            ZStack(alignment: .leading) {
                Text(self.errorMessage)
                    .font(.system(size: 12))
                    .foregroundColor(.red)
            }.padding(EdgeInsets(top: 4, leading: 18, bottom: 10, trailing: 0))
        } else {
            Spacer()
                .frame(width: 10, height: 18)
        }
    }
}

//struct ErrorView_Previews: PreviewProvider {
//    static var previews: some View {
//        ErrorView()
//    }
//}
