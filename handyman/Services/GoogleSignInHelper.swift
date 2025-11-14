//
//  GoogleSignInHelper.swift
//  handyman
//
//  Created by Lit Wa Yuen on 11/13/25.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift

struct GoogleResultTokens {
    let accessToken: String
    let idToken: String
}

final class GoogleSignInHelper {
    
    @MainActor
    func signIn() async throws -> GoogleResultTokens {
        guard let topViewController = Utils.shared.getTopViewController() else {
            throw URLError(.cannotFindHost)
        }
        let signInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topViewController)
        guard let idToken = signInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        
        let accessToken = signInResult.user.accessToken.tokenString
        return GoogleResultTokens(accessToken: accessToken, idToken: idToken)
    }
}
