//
//  ContentView.swift
//  handyman
//
//  Created by Lit Wa Yuen on 11/12/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject var appState: AppStateViewModel

    var body: some View {
        Group {
            NavigationStack {
                if appState.isLoggedIn() {
                    AppTabView()
                } else {
                    UserAuthView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
