//
//  CastleTextField.swift
//  CastleLink
//
//  Created by Volodymyr Shevchyk on 13.07.2022.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct CastleTextField: View {
    @Binding var text: String
    
    private let placeholder: String
    
    @State private var isSecure: Bool = false
    @State private var showContent: Bool = true
    
    init(_ prompt: String, text: Binding<String>, isSecure: Bool = false) {
        placeholder = prompt
        self._text = text
        _isSecure = State(initialValue: isSecure)
        _showContent = State(initialValue: !isSecure)
    }
    
    var body: some View {
        HStack {
            ZStack(alignment: .leading) {
                TextField("", text: $text)
                    .textFieldStyle(CastleTextFieldStyle())
                    .opacity(showContent ? 1.0 : 0.0)
                
                SecureField("", text: $text)
                    .textFieldStyle(CastleTextFieldStyle())
                    .opacity(showContent ? 0.0 : 1.0)
                
                if text.isEmpty {
                    Text(placeholder)
                        .font(.system(size: 14, weight: .regular))
                        .padding(EdgeInsets(top: 17.25, leading: 20, bottom: 18, trailing: 20))
                        .foregroundColor(.init("TextFieldPlaceholder"))
                        .allowsHitTesting(false)
                }
            }
            
            if isSecure {
                Button(action: {
                    showContent.toggle()
                }, label: {
                    Image(showContent ? "TextFieldEyeCrossed" : "TextFieldEye")
                })
                    .padding(15)
            }
        }
        .background(Color("BackgroundDark"))
        .cornerRadius(4)
        .shadow(color: .black, radius: 0, x: 0, y: -1.0 / UIScreen.main.scale)
    }
}

struct CastleTextField_Previews: PreviewProvider {
    @State static var inputText: String = "test"
    
    static var previews: some View {
        Group {
            CastleTextField("Prompt text", text: $inputText, isSecure: true)
                .previewLayout(.sizeThatFits)
            
            CastleTextField("Prompt text", text: $inputText)
                .previewLayout(.sizeThatFits)
        }
    }
}
