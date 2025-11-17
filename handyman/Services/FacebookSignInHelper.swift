//
//  FacebookSignInHelper.swift
//  handyman
//
//  Created by Lit Wa Yuen on 11/15/25.
//

import Foundation
import FacebookLogin

struct FacebookResultTokens {
    let accessToken: String
}

final class FacebookSignInHelper {
    
    @MainActor
    func signIn() async throws -> FacebookResultTokens {
        guard let topViewController = Utils.shared.getTopViewController() else {
            throw URLError(.cannotFindHost)
        }
        
        let loginManager = LoginManager()
        
        // Request permissions
        let _: LoginManagerLoginResult = try await withCheckedThrowingContinuation {
            (continuation: CheckedContinuation<LoginManagerLoginResult, Error>) in
            loginManager.logIn(permissions: ["public_profile","email"], from: topViewController) { loginResult, error in
                
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let loginResult = loginResult else {
                    continuation.resume(throwing: URLError(.unknown))
                    return
                }
                
                if loginResult.isCancelled {
                    continuation.resume(throwing: URLError(.cancelled))
                    return
                }
                
                continuation.resume(returning: loginResult)
            }
        }
        
        guard let tokenString = AccessToken.current?.tokenString else {
            throw URLError(.badServerResponse)
        }
        
        return FacebookResultTokens(accessToken: tokenString)
    }
}
