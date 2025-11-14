//
//  EmailLoginViewModel.swift
//  handyman
//
//  Created by Lit Wa Yuen on 11/13/25.
//
import SwiftUI

@MainActor
@Observable
final class EmailLoginViewModel {
    public var email: String = ""
    public var password: String = ""
    
    public var isLoading: Bool = false
    public var errorMessage: String? = nil
    
    public var resetEmailSent: Bool = false
    
    func isFormValid() -> Bool {
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var canSubmit: Bool { isFormValid() && !isLoading }

    
    func loginWithEmail() async -> UserInfo? {
        guard email.trimmingCharacters(in: .whitespacesAndNewlines).isValidEmail() else {
            errorMessage = "Invalid email format."
            return nil
        }
        isLoading = true
        defer {
            isLoading = false
        }
        do {
            let user = try await AuthenicationManager.shared.loginWithEmail(email: email, password: password)
            return user
        } catch let authError as AuthError  {
            errorMessage = authError.localizedDescription
        } catch {
            errorMessage = AuthError.unknown(error: error).localizedDescription
        }
        return nil
    }
    
    func resetPassword() async {
        guard email.trimmingCharacters(in: .whitespacesAndNewlines).isValidEmail() else {
            errorMessage = "Invalid email format."
            return
        }
        
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            try await AuthenicationManager.shared.resetPassword(email: email)
            resetEmailSent = true
        } catch let authError as AuthError  {
            errorMessage = authError.localizedDescription
        } catch {
            errorMessage = AuthError.unknown(error: error).localizedDescription
        }
        
    }
}
