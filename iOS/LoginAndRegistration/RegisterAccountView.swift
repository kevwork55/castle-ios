//
//  RegisterAccountView.swift
//  CastleLink
//
//  Created by Volodymyr Shevchyk on 15.07.2022.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct RegisterAccountView: View {
    var body: some View {
        Group {
//            TextField("Email", text: $email)
//                .foregroundColor(.white)
//            
//            TextField("Password", text: $password)
//                .foregroundColor(.white)
//            
//            TextField("Repeat Password", text: $repeatPassword)
//                .foregroundColor(.white)

            Button("Register") {
                
            }
            .buttonStyle(CastleButtonStyle(style: .highlighted))
            .frame(maxWidth: .infinity)
        }
    }
}

struct RegisterAccountView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterAccountView()
    }
}
