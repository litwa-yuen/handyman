//
//  SectionView.swift
//  handyman
//
//  Created by Lit Wa Yuen on 11/14/25.
//
import SwiftUI

struct SectionView<Content: View>: View {
    let title: String
    let content: Content
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            VStack(spacing: 0) {
                content
            }
            .background(.gray.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}
