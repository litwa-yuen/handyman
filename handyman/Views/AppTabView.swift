//
//  AppTabView.swift
//  handyman
//
//  Created by Lit Wa Yuen on 11/14/25.
//

import SwiftUI

struct AppTabView: View {

    @State var selectedTab = 0

    var body: some View {
        ZStack {
            // Main TabView
            TabView(selection: $selectedTab) {
                Tab("Task", systemImage: "list.star", value: 0) {
                    HomeView()
                }
                            
                Tab("Profile", systemImage: "person.fill", value: 1) {
                    SettingsView()
                }
            }
            .tabBarMinimizeBehavior(.onScrollDown)
        }

    }
}
