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
    @State private var showingAlert = false

    
    var body: some View {
        VStack(spacing: 16) {
            Text("Login With Email")
                .font(.title).bold()
            
            if let error = emailViewModel.errorMessage { // Conditionally display error message
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
            }
            
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
                    .opacity(emailViewModel.canSubmit ? 1.0 : 0.5)
            }
            .padding(.horizontal)
            .disabled(!emailViewModel.canSubmit)
            
            Button("Forget Password?") { sendPasswordReset() }
            .font(.footnote)
            .foregroundColor(.blue)
            .fontWeight(.bold)
            .padding(.top, 8)
            
            Spacer()
        }
        .alert("Check your email", isPresented: $showingAlert) {
               Button("OK") {
                   showingAlert = false
               }
           } message: {
               Text("Check your email for a link to reset your password.")
           }
    }
    
    private func sendPasswordReset()  {
        Task {
            await emailViewModel.resetPassword()
            if emailViewModel.resetEmailSent {
                showingAlert = true
            }
        }
    }
}

#Preview {
    EmailLoginView()
}
