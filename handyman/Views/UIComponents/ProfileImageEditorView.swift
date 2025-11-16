import SwiftUI
import PhotosUI

public struct ProfileImageEditorView: View {
    @EnvironmentObject var appState: AppStateViewModel

    @State var profileImage: UIImage?

    @State private var selectedImage: UIImage? = nil
    @State private var selectedPickerItem: PhotosPickerItem? = nil

    @State private var isEditorPresented: Bool = false
    @State private var isPhotoPickerPresented: Bool = false
    @State private var isConfirmationDialogPresented: Bool = false

    @State private var editorOffset: CGPoint = .zero
    @State private var editorScale: CGFloat = 1

    @State private var remoteURLString: String? = nil
    @State private var isLoadingRemoteImage: Bool = false

    public var body: some View {
        Group {
            if let image = profileImage {
                ProfileAvatarImageView(image: image, size: 120, showsEditBadge: true) {
                    isConfirmationDialogPresented = true
                }
            } else if isLoadingRemoteImage {
                ProfileAvatarProgressView(size: 120)
            } else {
                ProfileAvatarPlaceholderCircleView(size: 120, title: "Tap to Add") {
                    isPhotoPickerPresented = true
                }
            }
        }
        .onAppear {
            guard profileImage == nil else { return }
            if let urlString = appState.currentUser?.photoURL, let url = urlString.toSafeURL() {
                remoteURLString = urlString
                isLoadingRemoteImage = true
                Task {
                    defer { isLoadingRemoteImage = false }
                    do {
                        let (data, _) = try await URLSession.shared.data(from: url)
                        if let img = UIImage(data: data) {
                            await MainActor.run { profileImage = img }
                        }
                    } catch {
                        // optionally handle error
                    }
                }
            }
        }
        .photosPicker(isPresented: $isPhotoPickerPresented, selection: $selectedPickerItem)
        .confirmationDialog("Avtar", isPresented: $isConfirmationDialogPresented) {
            Button(action: {
                editorScale = 1
                editorOffset = .zero
                selectedPickerItem = nil
                isPhotoPickerPresented = true
            }) { Text("Photo Library") }
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

