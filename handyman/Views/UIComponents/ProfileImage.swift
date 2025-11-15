//
//  ProfileImageView.swift
//  handyman
//
//  Created by Lit Wa Yuen on 11/14/25.
//

import SwiftUI
import FirebaseAuth

struct ProfileImage: View {
    let url: String?
    var body: some View {
        if let url = url {
            AsyncImage(url: url.toSafeURL()) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()   // loading spinner
            }
            .frame(width: 80, height: 80)
            .clipShape(Circle())
        } else {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.gray)
        }
    }
}
