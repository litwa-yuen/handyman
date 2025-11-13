//
//  SignUpViewModel.swift
//  handyman
//
//  Created by Lit Wa Yuen on 11/13/25.
//

import SwiftUI

@MainActor
@Observable
final class SignUpViewModel {
    var name: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var email: String = ""

    func signUpWithEmail() async -> UserInfo? {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return nil
        }
        
        guard !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return nil
        }
        
        guard !confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return nil
        }
        
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return nil
        }
        do {
            let user = try await AuthenicationManager.shared.createUserAccount(withEmail: email, password: confirmPassword, name: name)
            return user
        } catch {
            print(error)
        }
        return nil
    }
}
