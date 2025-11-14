//
//  handymanApp.swift
//  handyman
//
//  Created by Lit Wa Yuen on 11/12/25.
//

import SwiftUI
import FirebaseCore

@main
struct handymanApp: App {
    @StateObject private var appState = AppStateViewModel()

    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
            .environmentObject(appState)
        }
    }
}
