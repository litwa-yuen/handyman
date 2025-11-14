//
//  EmailLoginView.swift
//  handyman
//
//  Created by Lit Wa Yuen on 11/13/25.
//

import SwiftUI

struct EmailLoginView: View {
    @State var emailViewModel: EmailLoginViewModel = EmailLoginViewModel()
    @EnvironmentObject var appState: AppStateViewModel
    @Environment(\.dismiss) var dismiss

    
    var body: some View {
        VStack(spacing: 16) {
            Text("Login With Email")
                .font(.title).bold()
            
            VStack(spacing: 16) {
                TextField("Email", text: $emailViewModel.email)
                    .textFieldStyle()
                SecureField("Password", text: $emailViewModel.password)
                    .textFieldStyle()
            }
            .padding(.horizontal)
            
            Button {
                Task {
                    if let user = await emailViewModel.loginWithEmail() {
                        appState.currentUser = user
                        dismiss()
                    }
                }
            } label: {
                Text("Login")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.red)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            .padding(.horizontal)
            
            Button("Forget Password?") { sendPasswordReset() }
            .font(.footnote)
            .foregroundColor(.blue)
            .fontWeight(.bold)
            .padding(.top, 8)
            
            Spacer()
        }
    }
    
    private func sendPasswordReset()  {
        Task {
            await emailViewModel.resetPassword()
        }
    }
}

#Preview {
    EmailLoginView()
}
