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
    @State var profileImage: UIImage? = nil
    @State var selectedImage: UIImage? = nil
    @State var selectedPickerItem: PhotosPickerItem? = nil
    
    @State var isEditorPresented: Bool = false
    @State var isPhotoPickerPresented: Bool = false
    @State var isConfirmationDialogPresented: Bool = false
    
    @State var editorOffset: CGPoint = .zero
    @State var editorScale: CGFloat = 1
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea() // full-screen black background
                VStack(spacing: 34) {
                    VStack(spacing: 8) {
                        if let profileImage = profileImage {
                            Image(uiImage: profileImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(.circle)
                                .onTapGesture {
                                    isConfirmationDialogPresented = true
                                }
                                .overlay(alignment: .bottomTrailing) {
                                    ZStack {
                                        Circle()
                                            .foregroundStyle(.gray)
                                            .frame(width: 25, height: 25)
                                        Image(systemName: "pencil")
                                    }
                                    .offset(x: -5, y: -5)
                                }
                        } else {
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 120, height: 120)
                                .overlay(
                                    Text("Tap to Add")
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                )
                                .onTapGesture {
                                    isPhotoPickerPresented = true
                                }
                        }
                        userInfo
                            .padding(.top)
                    }
                    sections
                }
                .padding(.horizontal)
                .navigationBarTitleDisplayMode(.inline)
                .photosPicker(isPresented: $isPhotoPickerPresented, selection: $selectedPickerItem)
                .confirmationDialog("Avtar", isPresented: $isConfirmationDialogPresented) {
                    Button(action: {
                        isEditorPresented = true
                    }) {
                        Text("Edit Photo")
                    }
                    
                    Button(action: {
                        editorScale = 1
                        editorOffset = .zero
                        selectedPickerItem = nil
                        isPhotoPickerPresented = true
                    }) {
                        Text("Choose new photo")
                    }
                } message: {
                    Text("Edit avatar")
                }
                .onChange(of: selectedPickerItem) { _, newValue in
                    Task {
                        if let newImage = await newValue?.loadUIImage() {
                            selectedImage = newImage
                        }
                    }
                }
                .onChange(of: selectedImage) { _, newValue in
                    guard newValue != nil else { return }
                    isEditorPresented = true
                }
                .fullScreenCover(isPresented: $isEditorPresented) {
                    EditProfileView($profileImage, selectedImage: selectedImage, scale: $editorScale, offset: $editorOffset)
                }
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
