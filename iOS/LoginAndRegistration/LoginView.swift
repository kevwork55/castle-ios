//
//  LoginView.swift
//  CastleLink
//
//  Created by Volodymyr Shevchyk on 14.07.2022.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var loginData: LoginData
    
    var body: some View {
        VStack {
            CastleTextField("Email", text: $loginData.email)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .showError($loginData.emailError)
            
            Spacer()
                .frame(height: loginData.emailError.isEmpty ? 18 : 7)
            
            CastleTextField("Password", text: $loginData.password, isSecure: true)
            
            GeometryReader { geometry in
                Button("Login") {
                    
                }
                .font(.system(size: 24, weight: .semibold))
                .buttonStyle(CastleFixedButtonStyle(isHighlighted: true, width: geometry.size.width))
            }
            
            Button("Recover Password") {

            }.frame(maxWidth: .infinity)
        }
    }
}

//struct LoginView_Previews: PreviewProvider {
//    @State static var email = ""
//    @State static var password = "ff"
//    
//    static var previews: some View {
//        LoginView(email: $email, password: $password)
//            .environmentObject(LoginData())
//            .previewLayout(.sizeThatFits)
//    }
//}
