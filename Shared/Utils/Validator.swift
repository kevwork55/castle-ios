//
//  Validator.swift
//  CastleLink
//
//  Created by Volodymyr Shevchyk on 21.07.2022.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import Foundation

struct Validator {
    // MARK: -
    static func isValidEmail(_ email: String) -> Bool {
        let regularExpresion = "^[\\w!#$%&’*+/=?`{|}~^-]+(?:\\.[\\w!#$%&’*+/=?`{|}~^-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,6}$"
        return Validator.isValid(email, regularExpresion: regularExpresion)
    }
    
    static func isValidPassword(_ password: String) -> Bool {
        return true
    }
    
    static func isValid(_ anyValue: String, regularExpresion: String) -> Bool {
        let predicate = NSPredicate(format:"SELF MATCHES %@", regularExpresion)
        return predicate.evaluate(with: anyValue)
    }
}
