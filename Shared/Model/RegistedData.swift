//
//  RegistedData.swift
//  CastleLink
//
//  Created by Volodymyr Shevchyk on 21.07.2022.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import Foundation
import FirebaseAuth

class RegistedData: ObservableObject {
    enum RegisterError: Error {
        case emailAlreadyInUse
        case noInternetConnection
        case other(String)
        
        var errorMessage: String {
            switch self {
            case .emailAlreadyInUse:
                return "The email address or password is incorrect"
            case .noInternetConnection:
                return "Network error (such as timeout, interrupted connection or unreachable host) has occurred."
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
    
    @Published var repeatPassword: String = "" {
      didSet {
          repeatPasswordError = ""
      }
    }
    
    @Published var emailError: String = ""
    @Published var passwordError: String = ""
    @Published var repeatPasswordError: String = ""
    
    func register(_ completionHandler: @escaping (Bool, RegisterError?) -> Void) {
        // validate fields
        let emailValidation = self.validateEmail()
        let passwordValidation = self.validatePassword()
        let repeatPasswordValidation = self.validateRepeatPassword()
        guard emailValidation && passwordValidation && repeatPasswordValidation else {
            completionHandler(false, nil)
            return
        }

        // send request to firebase
        Auth.auth().createUser(withEmail: email, password: password) { authREsult, error in
            if let _error = error {
                print(_error)

                let loginError: RegisterError

                if (_error as NSError).code == 17007 {
                    loginError = .emailAlreadyInUse
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
        
        
        guard self.password.count >= 6 else {
            self.passwordError = "The password should contain at least 6 characters"
            return false
        }
        
        return true
    }
    
    func validateRepeatPassword() -> Bool {
        guard self.repeatPassword.isEmpty == false else {
            self.repeatPasswordError = "Please enter a password"
            return false
        }
        
        guard self.repeatPassword == self.password else {
            self.repeatPasswordError = "Passwords do not match. Please try again"
            return false
        }
        
        return true
    }
    
}
