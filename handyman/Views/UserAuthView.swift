//
//  UserAuthView.swift
//  handyman
//
//  Created by Lit Wa Yuen on 11/12/25.
//

import SwiftUI

struct UserAuthView: View {
    @State private var userAuthViewModel: UserAuthViewModel = UserAuthViewModel()
    @EnvironmentObject var appState: AppStateViewModel
    @Environment(\.dismiss) var dismiss

    
    var body: some View {
        ZStack {
            //TODO: add background
            LinearGradient(
                gradient: Gradient(colors: [.black.opacity(0.3), .black.opacity(0.6)]),
                startPoint: .top,
                endPoint: .center
            )
            .ignoresSafeArea()

            VStack {
                Spacer()
                cardContent
                    .frame(maxWidth: 340)
                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .navigationBarHidden(true)
    }

    private var cardContent: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                //TODO: add image
                Text("Let's Get Started")
                    .font(.title3)
                    .bold()
            }

            VStack(spacing: 16) {
                LoginButtons(type: .apple) { signInWithApple() }
                LoginButtons(type: .google) { signInWithGoogle() }
                ORSeparator()
                NavigationLink(destination: EmailLoginView()) {
                    LoginButtons(type: .email) { }
                }
            }

            HStack {
                Text("Don't have an account?")
                    .font(.footnote)
                    .foregroundStyle(.black.opacity(0.5))
                NavigationLink("Create An Account") {
                    SignUpView()
                }
                .foregroundStyle(.white)
                .font(.footnote)
                .fontWeight(.bold)
            }
            .padding(.bottom, 12)
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.white.opacity(0.6))
        )
        .shadow(color: Color.black.opacity(0.2), radius: 12, x: 0, y: 4)
    }
    
    private func signInWithGoogle()  {
        Task {
            if let user = try? await userAuthViewModel.signInWithGoogle() {
                appState.currentUser = user
                dismiss()
            }
        }
    }
    
    private func signInWithApple()  {
        Task {
            if let user = try? await userAuthViewModel.signInWithApple() {
                appState.currentUser = user
                dismiss()
            }
        }
    }
}


#Preview {
    UserAuthView()
}
