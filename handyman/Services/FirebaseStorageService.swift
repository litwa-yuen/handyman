//
//  FirebaseStorageService.swift
//  handyman
//
//  Created by Lit Wa Yuen on 11/14/25.
//
import FirebaseStorage
import FirebaseAuth
import SwiftUI

class FirebaseStorageService {
    func uploadProfileImage(_ image: UIImage, completion: @escaping (URL?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        
        let storageRef = Storage.storage().reference()
            .child("profileImages/\(uid).jpg")
        
        // compress JPEG
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(nil)
            return
        }
        
        storageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("Upload error: \(error)")
                completion(nil)
                return
            }
            
            // Get the download URL
            storageRef.downloadURL { url, error in
                if let url = url {
                    completion(url)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    func updateFirebaseUserPhotoURL(_ url: URL, completion: @escaping (Bool) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(false)
            return
        }

        let request = user.createProfileChangeRequest()
        request.photoURL = url
        request.commitChanges { error in
            if let error = error {
                print("Failed to update photoURL: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func updateProfileImage(_ image: UIImage) {
        uploadProfileImage(image) { [self] url in
            guard let downloadURL = url else { return }
            
            updateFirebaseUserPhotoURL(downloadURL) { success in
                if success {
                    // savePhotoURLToFirestore(downloadURL)
                    print("Profile image updated!")
                }
            }
        }
    }
}
