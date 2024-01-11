//
//  ResetPasswordData.swift
//  CastleLink
//
//  Created by Volodymyr Shevchyk on 26.07.2022.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import Foundation
import FirebaseAuth

class ResetPasswordData: ObservableObject {
    enum ResetPasswordError: Error {
        case userNotFound
        case noInternetConnection
        case other(String)
        
        var errorMessage: String {
            switch self {
            case .userNotFound:
                return "The email address is incorrect"
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
    
    @Published var emailError: String = ""
    
    init(possibleEmail: String? = nil) {
        self._email = Published(initialValue: possibleEmail ?? "")
    }
    
    func reaset(_ completionHandler: @escaping (Bool, ResetPasswordError?) -> Void) {
        // validate field
        guard self.validateEmail() else {
            completionHandler(false, nil)
            return
        }
        
        // send request to firebase
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let _error = error {
                print(error!)
                
                let loginError: ResetPasswordError

                if (_error as NSError).code == 17011 {
                    loginError = .userNotFound
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
}
