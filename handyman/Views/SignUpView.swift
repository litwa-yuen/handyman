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
            Group {
                TextField( "Name", text: $signUpViewModel.name)
                TextField( "Email", text: $signUpViewModel.email)
                SecureField( "Password", text: $signUpViewModel.password)
                SecureField( "Confirm Password", text: $signUpViewModel.confirmPassword)
                
            }
            .textFieldStyle()
            
            Button {
                Task {
                    if let user = await signUpViewModel.signUpWithEmail() {
                        appState.currentUser = user
                        dismiss()
                    }
                }
            } label: {
                Text("Create An Account")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.red)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
    }
}

#Preview {
    SignUpView()
}
