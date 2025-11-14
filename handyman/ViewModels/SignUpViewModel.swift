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
    
    public var isLoading: Bool = false
    public var errorMessage: String? = nil

    func signUpWithEmail() async -> UserInfo? {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Please enter your name."
            return nil
        }
        
        guard !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Please enter your password."
            return nil
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return nil
        }
        
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Please enter your email."
            return nil
        }
        isLoading = true
        defer {
            isLoading = false
        }
        do {
            let user = try await AuthenicationManager.shared.createUserAccount(withEmail: email, password: confirmPassword, name: name)
            return user
        } catch let authError as AuthError  {
            errorMessage = authError.localizedDescription
        } catch {
            errorMessage = AuthError.unknown(error: error).localizedDescription
        }
        return nil
    }
}
