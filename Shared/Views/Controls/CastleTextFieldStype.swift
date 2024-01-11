//
//  CastleTextFieldStyle.swift
//  CastleLink
//
//  Created by Volodymyr Shevchyk on 12.07.2022.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct CastleTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(EdgeInsets(top: 17.25, leading: 20, bottom: 18, trailing: 20))
            .font(.system(size: 14, weight: .regular))
            .foregroundColor(.white)
            .frame(minHeight: 54)
    }
}

struct CastleTextFieldStyle_Previews: PreviewProvider {
    @State static var inputText: String = ""
    
    static var previews: some View {
        Group {
            TextField("Some placeholder", text: $inputText, onCommit:  {
                
            })
        }.textFieldStyle(CastleTextFieldStyle())
            .previewLayout(.sizeThatFits)
    }
}
