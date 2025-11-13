//
//  AuthenicationManager.swift
//  handyman
//
//  Created by Lit Wa Yuen on 11/13/25.
//
import FirebaseAuth
import Foundation

class AuthenicationManager {
    static let shared = AuthenicationManager()
    
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
    
}

