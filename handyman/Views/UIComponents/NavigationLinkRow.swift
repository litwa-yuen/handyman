//
//  NavigationLinkRow.swift
//  handyman
//
//  Created by Lit Wa Yuen on 11/14/25.
//
import SwiftUI

struct NavigationLinkRow: View {
    let icon: String
    let title: String
    let action: (() -> Void)?
    
    init(icon: String, title: String, action: (() -> Void)? = nil) {
        self.icon = icon
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Group {
            if let action = action {
                Button(action: action) {
                    rowContent
                }
            } else {
                rowContent
            }
        }
    }
    
    private var rowContent: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.black)
            
            Text(title)
                .foregroundColor(.black)
            Spacer()
        }
        
        .padding()
    }
}
    
