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
    var email: String = ""
    var password: String = ""
    
    func loginWithEmail() async -> UserInfo? {
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return nil
        }
        
        guard !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return nil
        }
        do {
            let user = try await AuthenicationManager.shared.loginWithEmail(email: email, password: password)
            return user
        } catch {
            print(error)
        }
        return nil
    }
}
