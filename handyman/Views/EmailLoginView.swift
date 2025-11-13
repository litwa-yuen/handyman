//
//  EmailLoginView.swift
//  handyman
//
//  Created by Lit Wa Yuen on 11/13/25.
//

import SwiftUI

struct EmailLoginView: View {
    @State var emailViewModel: EmailLoginViewModel = EmailLoginViewModel()
    
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
                        print(user.displayName)
                        print("Login Successful")
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
            
            Spacer()
        }
    }
}

#Preview {
    EmailLoginView()
}
