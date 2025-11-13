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
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
