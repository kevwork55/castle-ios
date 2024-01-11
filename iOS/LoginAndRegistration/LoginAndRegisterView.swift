//
//  LoginAndRegisterView.swift
//  CastleLink
//
//  Created by Volodymyr Shevchyk on 11.07.2022.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

struct LoginAndRegisterView: View {
    @EnvironmentObject var userData: UserData
    
    @State private var selectedMode = 0
    @State private var showLoading = false
    
    @StateObject private var loginData: LoginData = .init()
    @StateObject private var registerData: RegistedData = .init()
    
    @State private var isErrorMessagePressented: Bool = false
    @State private var errorMessage: String = ""
    
    @State private var isForgotVissible: Bool = false
    
    // MARK: -
    
    var body: some View {
        ZStack() {
            Color("BackgroundDark")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                CastleLinkHeaderView(title: "Enable All Features With an Account")
                
                Spacer()
                
                ZStack() {
                    LinearGradient(gradient: Gradient(colors: [ Color("BarGradient0"), Color("BarGradient1") ]), startPoint: .top, endPoint: .bottom)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack(alignment: .center, spacing: 0) {
                        self.dynamicBody
                        
                        Spacer()
                            .frame(height: 6)
                        Spacer()
                        
                        NavigationLink( destination: AboutView() ) {
                            Text("About Castle Link")
                                .foregroundColor(.white)
                                .font(.system(size: 12, weight: .medium))
                                .padding(EdgeInsets(top: 3, leading: 20, bottom: 3, trailing: 20))
                        }
                        
                        Spacer()
                            .frame(maxHeight: 6)

                        NavigationLink(destination: DemoSelectView() ) {
                            Text("Demo Mode")
                                .foregroundColor(.white)
                                .font(.system(size: 12, weight: .medium))
                                .padding(EdgeInsets(top: 3, leading: 20, bottom: 3, trailing: 20))
                        }
                        
                        CastleLinkFooterView()
                    }
                }
            }
            
            if showLoading {
                LoadingView()
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .alert(isPresented: $isErrorMessagePressented) {
            Alert(title: Text(self.errorMessage))
        }
        .navigationBarHidden(true)
        
    }
    
    private var dynamicBody: some View {
        ZStack() {
            VStack(alignment: .leading) {
                LoginRegisterActionRow(selectedMode: $selectedMode, onQuickLink: onQuickLinkPressed)
                
                Spacer()
                    .frame(height: 18)

                if selectedMode == 1 {
                    VStack(alignment: .leading, spacing: 0) {
                        CastleTextField("Email", text: $registerData.email)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .keyboardType(.emailAddress)
                        
                        ErrorView(errorMessage: $registerData.emailError)
                        
                        CastleTextField("Password", text: $registerData.password, isSecure: true)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                        
                        ErrorView(errorMessage: $registerData.passwordError)
                        
                        CastleTextField("Repeat Password", text: $registerData.repeatPassword, isSecure: true)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                        
                        ErrorView(errorMessage: $registerData.repeatPasswordError)
                    }
                    
                    Spacer()
                        .frame(height: 2)

                    GeometryReader { geometry in
                        Button("Register") {
                            self.onRegistrationPressed()
                        }
                        .font(.system(size: 24, weight: .semibold))
                        .buttonStyle(CastleFixedButtonStyle(isHighlighted: true, width: geometry.size.width))
                    }
                } else {
                    VStack(alignment: .leading, spacing: 0) {
                        CastleTextField("Email", text: $loginData.email)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .keyboardType(.emailAddress)
                        
                        ErrorView(errorMessage: $loginData.emailError)
                        
                        CastleTextField("Password", text: $loginData.password, isSecure: true)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                        
                        ErrorView(errorMessage: $loginData.passwordError)
                    }
                    
                    Spacer()
                        .frame(height: 2)
                    
                    GeometryReader { geometry in
                        Button("Login") {
                            self.onLoginPressed()
                        }
                        .font(.system(size: 24, weight: .semibold))
                        .buttonStyle(CastleFixedButtonStyle(isHighlighted: true, width: geometry.size.width))
                    }
                    
                    Spacer()
                        .frame(height: 26)
                    
                    NavigationLink(destination: ForgotPasswordView(isVissible: $isForgotVissible), isActive: $isForgotVissible) {
                        Text("Recover Password")
                            .font(.system(size: 12))
                            .foregroundColor(Color("AccentColor"))
                    }
                    .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                    EmptyView()
                }
            }
        }.padding(EdgeInsets(top: 18, leading: 20, bottom: 0, trailing: 20))
    }
    
    private func onLoginPressed() {
        print("quickLinkPressed")
        showLoading = true
        
        self.loginData.login { success, error in
            if success {
                userData.isSignedIn = true
            } else if let _error = error {
                self.errorMessage = _error.errorMessage
                self.isErrorMessagePressented = true
            }

            showLoading = false
        }
    }
    
    private func onRegistrationPressed() {
        print("quickLinkPressed")
        showLoading = true
        
        self.registerData.register { success, error in
            if success {
                userData.isSignedIn = true
            } else if let _error = error {
                self.errorMessage = _error.errorMessage
                self.isErrorMessagePressented = true
            }
            
            showLoading = false
        }
    }
    
    private func onQuickLinkPressed() {
        print("quickLinkPressed")
        showLoading.toggle()
    }
    
    private func onAboutPressed() {
        print("onAboutPressed")
    }
}

struct LoginAndRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        LoginAndRegisterView()
    }
}
