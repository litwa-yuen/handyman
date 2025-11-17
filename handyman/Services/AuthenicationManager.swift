//
//  AuthenicationManager.swift
//  handyman
//
//  Created by Lit Wa Yuen on 11/13/25.
//
import FirebaseAuth
import Foundation
import AuthenticationServices
import CryptoKit

class AuthenicationManager {
    static let shared = AuthenicationManager()
    
    private var currentNonce: String?
    
    private init() {}
    
    func getLoggedInUser() -> UserInfo? {
        guard let user = Auth.auth().currentUser else {
            return nil
        }
        return UserInfo(user: user)
    }
    
    func createUserAccount(withEmail email: String, password: String, name: String) async throws -> UserInfo {
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        let changeRequest = authResult.user.createProfileChangeRequest()
        changeRequest.displayName = name
        try await changeRequest.commitChanges()
        return UserInfo(user: authResult.user)
    }
    
    func loginWithEmail(email: String, password: String) async throws -> UserInfo {
        let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return UserInfo(user: authResult.user)
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func signInWithApple(token: AppleAuthResultModel) async throws -> UserInfo {
        let credential = OAuthProvider.credential(providerID: AuthProviderID.apple,
                                                  idToken: token.idToken,
                                                  rawNonce: token.nonce ?? "")
        let authResult = try await Auth.auth().signIn(with: credential)
        return UserInfo(user: authResult.user)
    }
    
    func signInWithGoogle(tokens: GoogleResultTokens) async throws -> UserInfo {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        let authResult = try await Auth.auth().signIn(with: credential)
        return UserInfo(user: authResult.user)
    }
    
    func signInWithFacebook(token: FacebookResultTokens) async throws -> UserInfo {
        let credential = FacebookAuthProvider.credential(withAccessToken: token.accessToken)
        let authResult = try await Auth.auth().signIn(with: credential)
        return UserInfo(user: authResult.user)
    }
    
    func updateCurrentUserDisplayName(_ name: String) async throws {
        guard let user = Auth.auth().currentUser else {
            return
        }
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = name
        try await changeRequest.commitChanges()
    }
}

