//
//  CastleLinkApp.swift
//  CastleLink
//
//  Created by Gerrit Goossen on 4/5/22.
//  Copyright © 2022 Castle Creations. All rights reserved.
//

import UIKit
import SwiftUI
import FirebaseCore

@main
struct CastleLinkApp: App {
	@UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
//	@StateObject private var productData = ProductData.shared
    @StateObject private var userData = UserData()
    

	// MARK: -

	var body: some Scene {
		WindowGroup {
			NavigationView {
                if userData.isSignedIn {
                    HomeView()
                } else {
                    LoginAndRegisterView()
                }
                
            }
            .preferredColorScheme(.dark)
//			.environmentObject(productData)
            .environmentObject(userData)
        }
	}
}

// MARK: -

class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {

	func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        // setup firebase
        FirebaseApp.configure()
        
		// setup the navigation bar appearance
		let appearance = UINavigationBarAppearance()
		let textAttributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: UIColor(named: "TextPrimary")!
		]

		appearance.configureWithOpaqueBackground()
		appearance.backgroundColor = UIColor(named: "ViewBackground")
		appearance.largeTitleTextAttributes = textAttributes
		appearance.titleTextAttributes = textAttributes

		UINavigationBar.appearance().standardAppearance = appearance
		UINavigationBar.appearance().scrollEdgeAppearance = appearance

		return true
	}

}
