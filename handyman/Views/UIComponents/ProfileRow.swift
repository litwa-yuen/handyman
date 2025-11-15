//
//  ProfileRow.swift
//  handyman
//
//  Created by Lit Wa Yuen on 11/14/25.
//

import SwiftUI

struct ProfileRow: View {
    let icon: String
    let title: String
    var badgeCount: Int? = nil
    
    var body : some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 24))
                
            Text(title)
            Spacer()
            if let count = badgeCount {
                Text("\(count)")
                    .font(.caption)
                    .padding(10)
                    .background(Circle().fill(Color.gray.opacity(0.2)))
            }
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
    }
}

