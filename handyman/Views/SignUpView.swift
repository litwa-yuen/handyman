//
//  SignUpView.swift
//  handyman
//
//  Created by Lit Wa Yuen on 11/13/25.
//

import SwiftUI

struct SignUpView: View {
    @State var signUpViewModel = SignUpViewModel()
    @EnvironmentObject var appState: AppStateViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Text ( "Create An Account")
                .font(.title)
                .fontWeight(.bold)
            if let error = signUpViewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
            }
            
            Group {
                TextField( "Name", text: $signUpViewModel.name)
                TextField( "Email", text: $signUpViewModel.email)
                SecureField( "Password", text: $signUpViewModel.password)
                SecureField( "Confirm Password", text: $signUpViewModel.confirmPassword)
                
            }
            .textFieldStyle()
            
            Button { signUpWithEmail() } label: {
                Text("Create An Account")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.red)
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .opacity(signUpViewModel.canSubmit ? 1.0 : 0.5)
            }
            .disabled(!signUpViewModel.canSubmit)
            
            Spacer()
        }
    }
    
    private func signUpWithEmail()  {
        Task {
            if let user = await signUpViewModel.signUpWithEmail() {
                appState.currentUser = user
                dismiss()
            }
        }
    }
}

#Preview {
    SignUpView()
}
