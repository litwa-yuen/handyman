//
//  HomeView.swift
//  handyman
//
//  Created by Lit Wa Yuen on 11/13/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppStateViewModel
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    var body: some View {
        ZStack {
            (isDarkMode ? Color.black : Color.white).ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Welcome \(appState.currentUser?.displayName ?? "User")")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(isDarkMode ? .white : .black)
                Button  {
                    Task {
                        try appState.signOut()
                    }
                } label: {
                    Text("Logout")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    HomeView()
}
