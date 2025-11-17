//
//  UserAuthViewModel.swift
//  handyman
//
//  Created by Lit Wa Yuen on 11/13/25.
//

import SwiftUI

@MainActor
@Observable
class UserAuthViewModel {
    
    func signInWithApple() async throws -> UserInfo {
        let signInWithAppleHelper = AppleSignInHelper()
        let signInWithAppleResult = try await signInWithAppleHelper.startSignInWithAppleFlow()
        
        let userInfo = try await AuthenicationManager.shared.signInWithApple(token: signInWithAppleResult)
        
        return userInfo
    }
    
    func signInWithGoogle() async throws -> UserInfo {
        let tokens = try await GoogleSignInHelper().signIn()
        let userInfo = try await AuthenicationManager.shared.signInWithGoogle(tokens: tokens)
        return userInfo
    }
    
    func signInWithFacebook() async throws -> UserInfo {
        let token = try await FacebookSignInHelper().signIn()
        let userInfo = try await AuthenicationManager.shared.signInWithFacebook(token: token)
        return userInfo
    }
}
