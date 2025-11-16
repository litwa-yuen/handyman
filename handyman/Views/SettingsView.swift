//
//  SettingsView.swift
//  handyman
//
//  Created by Lit Wa Yuen on 11/14/25.
//
import SwiftUI
import PhotosUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppStateViewModel
    @State var profileImage: UIImage?
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea() // full-screen black background
                VStack(spacing: 34) {
                    VStack(spacing: 8) {
                        ProfileImageEditorView()
                        userInfo
                            .padding(.top)
                    }
                    sections
                }
                .padding(.horizontal)
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }

    
    var sections: some View {
        Group {
            SectionView(title: "Inventories") {
                ProfileRow(icon: "building.2",title: "My tasks", badgeCount: 2)
                //ProfileRow(icon: "questionmark.circle", title: "Support")
            }
            SectionView(title: "Preferences") {
                //ToggleRow(icon:"bell", title: "Push notifications", isOn: $pushNotifications)
                //ToggleRow(icon: "faceid", title: "Face ID", ison: $faceID)
                //NavigationLinkRow(icon:"key", title: "PIN Code")
                NavigationLinkRow(icon: "arrowshape.turn.up.left", title: "Logout", action: {
                    Task {
                        try appState.signOut()
                    }
                })
            }
        }
    }
    
    var userInfo: some View {
        VStack (spacing: 4) {
            Text (appState.currentUser?.displayName! ?? "" )
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
            
            Text(appState.currentUser?.email ?? "")
                .foregroundColor(.gray)
            
            Button ("Edit profile") {
            }
            .font(.subheadline.bold())
            .foregroundColor(.black)
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
            .background(.white, in: Capsule())
            .padding(.top)
        }
    }
}

