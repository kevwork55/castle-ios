//
//  UserData.swift
//  CastleLink
//
//  Created by Volodymyr Shevchyk on 22.07.2022.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import Foundation
import SwiftUI

class UserData: ObservableObject {
    @Published var isSignedIn: Bool {
        didSet {
            UserDefaults.standard.set(isSignedIn, forKey: "isSignedIn")
        }
    }
    
    init() {
        _isSignedIn = Published(initialValue: UserDefaults.standard.bool(forKey: "isSignedIn"))
    }
}
