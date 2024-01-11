//
//  CastleLinkError.swift
//  CastleLink
//
//  Created by Volodymyr Shevchyk on 27.07.2022.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import Foundation

enum CastleLinkError: Error, CustomStringConvertible, LocalizedError {
    
    
    case userNotFound
    case emailAlreadyInUse
    case noInternetConnection
    case wrongPassword
    case somethingWentWrong
    case other(String?)
    
    var errorMessage: String {
        switch self {
        case .userNotFound:
            return "The email address or password is incorrect"
        case .emailAlreadyInUse:
            return "The email address or password is incorrect"
        case .noInternetConnection:
            return "Network error (such as timeout, interrupted connection or unreachable host) has occurred."
        case .wrongPassword:
            return "The email address or password is incorrect"
        case .somethingWentWrong:
            return "Something went wrong"
        case .other(let otherError):
            return otherError ?? CastleLinkError.somethingWentWrong.localizedDescription
        }
    }
    
    public var description: String {
        switch self {
        case .userNotFound:
            return "The email address or password is incorrect"
        case .emailAlreadyInUse:
            return "The email address or password is incorrect"
        case .noInternetConnection:
            return "Network error (such as timeout, interrupted connection or unreachable host) has occurred."
        case .wrongPassword:
            return "The email address or password is incorrect"
        case .somethingWentWrong:
            return "Something went wrong"
        case .other(let otherError):
            return otherError ?? CastleLinkError.somethingWentWrong.localizedDescription
        }
    }
    
    public var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "The email address or password is incorrect"
        case .emailAlreadyInUse:
            return "The email address or password is incorrect"
        case .noInternetConnection:
            return "Network error (such as timeout, interrupted connection or unreachable host) has occurred."
        case .wrongPassword:
            return "The email address or password is incorrect"
        case .somethingWentWrong:
            return "Something went wrong"
        case .other(let otherError):
            return otherError ?? CastleLinkError.somethingWentWrong.localizedDescription
        }
    }
}


//if (_error as NSError).code == 17011 {
//    loginError = .userNotFound
//} else if (_error as NSError).code == 17020 {
//    loginError = .noInternetConnection
//} else {
//    loginError = .other("Something went wrong. Please try again")
//}

//if (_error as NSError).code == 17011 {
//    loginError = .userNotFound
//} else if (_error as NSError).code == 17009 {
//    loginError = .wrongPassword
//} else if (_error as NSError).code == 17020 {
//    loginError = .noInternetConnection
//} else {
//    loginError = .other("Something went wrong. Please try again")
//}

//if (_error as NSError).code == 17007 {
//    loginError = .emailAlreadyInUse
//} else if (_error as NSError).code == 17020 {
//    loginError = .noInternetConnection
//} else {
//    loginError = .other("Something went wrong. Please try again")
//}
