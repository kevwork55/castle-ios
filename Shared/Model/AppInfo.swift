//
//  AppInfo.swift
//  CastleLink
//
//  Created by Volodymyr Shevchyk on 21.07.2022.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import Foundation

struct AppInfo {
    var appVersion: String {
        var result = "1.0"
        
        if let info = Bundle.main.infoDictionary,
           let marketingVersion = info["CFBundleShortVersionString"] as? String {
            
            result = "\(marketingVersion)"
            
            // add the build version
            if let buildVersion = info["CFBundleVersion"] as? String {
                result += " (\(buildVersion))"
            }
        }
        
        return result
    }
    
    var platform: String {
#if os(macOS)
        return "macOS"
#else
        return "iOS"
#endif // os(macOS)
    }
}
