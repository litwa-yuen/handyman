//
//  EditProfileView.swift
//  handyman
//
//  Created by Lit Wa Yuen on 11/14/25.
//
import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @Binding var profileImage: UIImage?
    let selectedImage: UIImage?
    @Binding var scale: CGFloat
    @Binding var offset: CGPoint
        
    @State private var lastScale: CGFloat = 1.0
    @State private var lastOffset: CGPoint = .zero
    @State private var showImagePicker: Bool = true

    @Environment(\.dismiss) var dismiss
        
    let circleDiameter: CGFloat = 300
    
    init (
        _ profileImage: Binding<UIImage?>,
        selectedImage: UIImage?,
        scale: Binding<CGFloat>,
        offset: Binding<CGPoint>
    ) {
        self.selectedImage = selectedImage
        _profileImage = profileImage
        _scale = scale
        _offset = offset
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .overlay {
                    Circle()
                        .frame(width: circleDiameter, height: circleDiameter)
                        .blendMode(.destinationOut)
                }
                .compositingGroup()
                .background {
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                            .scaleEffect(scale)
                            .offset(x: offset.x, y: offset.y)
                    }
                }
                .clipped()
            HStack {
                Button(action: { dismiss() }) {
                    Text("Cancel")
                        .bold()
                        .foregroundStyle(.white)
                }
                Spacer()
                
                Button {
                    Task {
                        await saveCroppedImage()
                    }
                }
                label: {
                    Text("Continue")
                        .bold()
                        .foregroundStyle(.black)
                        .frame(width: 120, height: 55)
                        .background(.white, in: .capsule)
                }
            }
            .padding()
            .padding(.bottom, 24)
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .ignoresSafeArea()
        .gesture(
            SimultaneousGesture(
                DragGesture()
                    .onChanged { value in
                        let newOffset = CGPoint(
                            x: lastOffset.x + value.translation.width,
                            y: lastOffset.y + value.translation.height
                        )
                        offset = clampedOffsetWithinScreen(for: newOffset)
                    }
                    .onEnded { _ in
                        lastOffset = offset
                    },
                MagnificationGesture()
                    .onChanged { value in
                        scale = lastScale * value
                    }
                    .onEnded { _ in
                        lastScale = scale
                        offset = clampedOffsetWithinScreen(for: offset)
                        lastOffset = offset
                    }
            )
            
        )
        .onAppear {
            scale = 1
            lastScale = 1
            offset = .zero
            lastOffset = .zero
        }
    }
    
    private func clampedOffsetWithinScreen(for proposedOffset: CGPoint) -> CGPoint {
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first else {
            return CGPoint.zero
        }
        
        
        // screen is NOT optional
        let screen = windowScene.screen
        let screenBounds = screen.bounds
        let screenWidth = screenBounds.width
        let screenHeight = screenBounds.height
        
        let maxX = screenWidth / 2
        let maxY = screenHeight / 2
        
        return CGPoint(
            x: min(max(proposedOffset.x, -maxX), maxX),
            y: min(max(proposedOffset.y, -maxY), maxY)
        )
    }
    
    @MainActor
    private func saveCroppedImage() async {
        guard selectedImage != nil else { return }

        // Get windowScene + window
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first,
              let window = windowScene.keyWindow else {
            return
        }

        // screen is NOT optional
        let screen = windowScene.screen
        let screenBounds = screen.bounds

        let cropRect = CGRect(
            x: (screenBounds.width - circleDiameter) / 2,
            y: (screenBounds.height - circleDiameter) / 2,
            width: circleDiameter,
            height: circleDiameter
        )

        let renderer = UIGraphicsImageRenderer(bounds: cropRect)

        let cropped = renderer.image { _ in
            window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
        }

        self.profileImage = cropped

        FirebaseStorageService.shared.updateProfileImage(cropped)
    
        dismiss()
    }

    
}

extension PhotosPickerItem {
    func loadUIImage() async -> UIImage? {
        if let data = try? await loadTransferable(type: Data.self), let image = UIImage(data: data) {
            return image
        } else {
            return nil
        }
    }
}
