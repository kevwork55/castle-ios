//
//  HideKeyboard.swift
//  CastleLink
//
//  Created by Volodymyr Shevchyk on 26.07.2022.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import SwiftUI

#if canImport(UIKit)
import UIKit

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
