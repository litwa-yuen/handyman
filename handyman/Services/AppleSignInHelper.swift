//
//  AppleSignInHelper.swift
//  handyman
//
//  Created by Lit Wa Yuen on 11/13/25.
//

import Foundation
import SwiftUI
import CryptoKit
import AuthenticationServices


struct AppleAuthResultModel {
    var idToken: String
    var nonce: String?
    var fullName: PersonNameComponents
}


@MainActor
final class AppleSignInHelper: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding{
    
    private var continuation: CheckedContinuation<AppleAuthResultModel, Error>?
    fileprivate var currentNonce: String?
    
    func startSignInWithAppleFlow() async throws -> AppleAuthResultModel {
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            
            let nonce = randomNonceString()
            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            
            request.requestedScopes = [.fullName, .email]
            request.nonce = sha256(nonce)
            
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
            
        }
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition (length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes (kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError (
                "Unable to generate nonce, SecRandomCopyBytes failed with OSstatus \(errorCode)"
            )
        }
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        return String (nonce)
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashedString = hashedData.compactMap(\.description).joined()
        return hashedString
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential, let appleIDToken = credential.identityToken, let idTokenString = String(data: appleIDToken, encoding: .utf8) {
            let result = AppleAuthResultModel(idToken: idTokenString, nonce: currentNonce, fullName: credential.fullName!)
            continuation?.resume (returning: result)
        } else {
            continuation?.resume (throwing: URLError(. badServerResponse))
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error:Error) {
        continuation?.resume (throwing: error)
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        Utils.shared.getTopViewController()?.view.window ?? ASPresentationAnchor()
    }
}
