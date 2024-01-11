//
//  LoginData.swift
//  CastleLink
//
//  Created by Volodymyr Shevchyk on 21.07.2022.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import Foundation
import FirebaseAuth

class LoginData: ObservableObject {
    enum LoginError: Error {
        case userNotFound
        case noInternetConnection
        case wrongPassword
        case other(String)
        
        var errorMessage: String {
            switch self {
            case .userNotFound:
                return "The email address or password is incorrect"
            case .noInternetConnection:
                return "Network error (such as timeout, interrupted connection or unreachable host) has occurred."
            case .wrongPassword:
                return "The email address or password is incorrect"
            case .other(let otherError):
                return otherError
            }
        }
    }
    
    @Published var email: String = "" {
       didSet {
           if email.isEmpty {
               emailError = "Please enter your email address"
           } else {
               emailError = ""
           }
       }
   }
    
    @Published var password: String = "" {
      didSet {
          if password.isEmpty {
              passwordError = "Please enter a password"
          } else {
              passwordError = ""
          }
      }
    }
    
    @Published var emailError: String = ""
    @Published var passwordError: String = ""
    
    func login(_ completionHandler: @escaping (Bool, LoginError?) -> Void) {
        // validate fields
        let emailValidation = self.validateEmail()
        let passwordValidation = self.validatePassword()
        guard emailValidation && passwordValidation else {
            completionHandler(false, nil)
            return
        }
        
        // send request to firebase
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let _error = error {
                print(error!)
                
                let loginError: LoginError

                if (_error as NSError).code == 17011 {
                    loginError = .userNotFound
                } else if (_error as NSError).code == 17009 {
                    loginError = .wrongPassword
                } else if (_error as NSError).code == 17020 {
                    loginError = .noInternetConnection
                } else {
                    loginError = .other("Something went wrong. Please try again")
                }
                
                completionHandler(false, loginError)
            } else {
                completionHandler(true, nil)
            }

        }
    }
    
    // MARK: - Private functions
    
    func validateEmail() -> Bool {
        guard self.email.isEmpty == false else {
            self.emailError = "Please enter your email address"
            return false
        }
        
        guard Validator.isValidEmail(self.email) else {
            self.emailError = "Please enter email address in a valid format"
            return false
        }
        
        return true
    }
    
    func validatePassword() -> Bool {
        guard self.password.isEmpty == false else {
            self.passwordError = "Please enter a password"
            return false
        }
        
        return true
    }
}
