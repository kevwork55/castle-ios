//
//  ForgotPasswordView.swift
//  CastleLink
//
//  Created by Volodymyr Shevchyk on 22.07.2022.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI
import GameController

struct ForgotPasswordView: View {
    @Binding var isVissible: Bool
    
    @State private var successContent = false
    @State private var showLoading = false
    
    @State private var isErrorMessagePressented: Bool = false
    @State private var errorMessage: String = ""
    @StateObject private var resetPasswordData: ResetPasswordData = ResetPasswordData()
    
    init(isVissible: Binding<Bool>, possibleEmail: String? = nil) {
        self._isVissible = isVissible
        //        self._resetPasswordData = StateObject(wrappedValue: ResetPasswordData(possibleEmail: possibleEmail))
    }
    
    var body: some View {
        GeometryReader { geometry in
            let gradient = Gradient(colors: [ Color("BarGradient0"), Color("BarGradient1") ])
            LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center, spacing: 0) {
                HStack {
                    Button(action: {
                        self.isVissible = false
                    }, label: {
                        Image("BackArrow")
                    })
                    
                    Spacer()
                }
                
                Spacer(minLength: 8).fixedSize(horizontal: true, vertical: false)
                
                ZStack {
                    Circle()
                        .fill(Color("BackgroundDark"))
                        .frame(width: 110, height: 110)
                    
                    successContent ? Image("ResetPasswordSuccess") : Image("ResetPasswordIcon")
                }
                
                Spacer()
                    .frame(height: 16)
                
                Text("Password reset")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                    .frame(height: 10)
                
                let message = successContent ? "An email has been sent to reset your password" : "Please enter your email to recover your password"
                Text(message)
                    .font(.system(size: 12))
                    .foregroundColor(.white)
                
                if successContent == false {
                    Spacer()
                        .frame(height: 24)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        CastleTextField("Email", text: $resetPasswordData.email)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .keyboardType(.emailAddress)
                        
                        ErrorView(errorMessage: $resetPasswordData.emailError)
                    }
                    
                    Button("Submit") {
                        onSubmitPressed()
                    }
                    .font(.system(size: 24, weight: .semibold))
                    .buttonStyle(CastleFixedButtonStyle(isHighlighted: true, width: geometry.size.width - 36))
                }
                
                Spacer(minLength: 8).fixedSize(horizontal: true, vertical: false)
                
                CastleLinkFooterView()
                    .padding(.bottom, 31)
            }
            .edgesIgnoringSafeArea(.bottom)
            .padding(.leading, 18)
            .padding(.trailing, 18)
            
            if showLoading {
                LoadingView()
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .alert(isPresented: $isErrorMessagePressented) {
            Alert(title: Text(self.errorMessage))
        }
        .navigationBarHidden(true)
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    private func onSubmitPressed() {
        showLoading = true
        
        self.resetPasswordData.reaset { success, error in
            if success {
                self.successContent = true
            } else if let _error = error {
                self.errorMessage = _error.errorMessage
                self.isErrorMessagePressented = true
            }
            
            showLoading = false
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    @State static var isVissible: Bool = true
    
    static var previews: some View {
        ForgotPasswordView(isVissible: $isVissible, possibleEmail: "vs.jr@indeema.com")
    }
}
