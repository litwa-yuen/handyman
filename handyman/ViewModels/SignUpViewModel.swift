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
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    public var isLoading: Bool = false
    public var errorMessage: String? = nil

    /// Returns true when all fields are non-empty after trimming whitespace and newlines.
    func isFormValid() -> Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    


    /// Returns true when the form can be submitted (valid and not loading).
    var canSubmit: Bool { isFormValid() && !isLoading }

    func signUpWithEmail() async -> UserInfo? {
        errorMessage = nil

        guard email.trimmingCharacters(in: .whitespacesAndNewlines).isValidEmail() else {
            errorMessage = "Invalid email format."
            return nil
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
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

