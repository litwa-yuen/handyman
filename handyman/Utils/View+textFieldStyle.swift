//
//  View+textFieldStyle.swift
//  handyman
//
//  Created by Lit Wa Yuen on 11/13/25.
//

import SwiftUI

extension View {
    public func textFieldStyle() -> some View {
        self.padding()
            .background(.secondary.opacity(0.2))
            .cornerRadius(8)
            .padding(.horizontal)
    }
}
