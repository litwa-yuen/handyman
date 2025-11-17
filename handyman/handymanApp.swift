//
//  handymanApp.swift
//  handyman
//
//  Created by Lit Wa Yuen on 11/12/25.
//

import SwiftUI
import FirebaseCore
import FBSDKCoreKit

@main
struct handymanApp: App {
    @StateObject private var appState = AppStateViewModel()
    
    init() {
        FirebaseApp.configure()
        ApplicationDelegate.shared.application(
            UIApplication.shared,
            didFinishLaunchingWithOptions: nil
        )
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
            .environmentObject(appState)
            .onOpenURL { url in
                ApplicationDelegate.shared.application(
                    UIApplication.shared,
                    open: url,
                    sourceApplication: nil,
                    annotation: UIApplication.OpenURLOptionsKey.annotation
                )
            }
        }
    }
}
