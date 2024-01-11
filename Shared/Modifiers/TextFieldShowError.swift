//
//  TextFieldShowError.swift
//  CastleLink
//
//  Created by Volodymyr Shevchyk on 19.07.2022.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

fileprivate struct TextFieldShowError: ViewModifier {
    @Binding var errorMessage: String
    
    func body(content: Content) -> some View {
        if self.errorMessage.isEmpty == false {
            VStack(alignment: .leading, spacing: 6) {
                content
                
                Text(self.errorMessage)
                    .padding(.leading, 18)
                    .font(.system(size: 12))
                    .foregroundColor(.red)
                
                Spacer()
                    .frame(height: 18)
            }
        } else {
            content
            
            Spacer()
                .frame(height: 7)
        }
    }
}

extension View {
    func showError(_ error: Binding<String>) -> some View {
        modifier(TextFieldShowError(errorMessage: error))
    }
}

//struct TextFieldShowError_Previews: PreviewProvider {
//    static var previews: some View {
//        CastleTextField()
//        TextFieldShowError(errorMessage: "Some error")
//    }
//}
