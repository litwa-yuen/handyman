//
//  ORSeparator.swift
//  handyman
//
//  Created by Lit Wa Yuen on 11/12/25.
//

import SwiftUI

struct ORSeparator: View {
    var body: some View {
        HStack {
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(.separator))
            Text("or")
                .foregroundColor(.secondary)
                .font(.subheadline)
                .padding(.horizontal)
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(.separator))
        }
        .padding(.horizontal)
    }
}
