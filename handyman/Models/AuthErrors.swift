//
//  AuthErrors.swift
//  handyman
//
//  Created by Lit Wa Yuen on 11/13/25.
//

import Foundation

/// A domain-specific error type for authentication flows.
public enum AuthError: Error, Equatable {
    case invalidCredentials
    case userNotFound
    case emailAlreadyInUse
    case weakPassword
    case unauthorized
    case sessionExpired
    case network
    case cancelled
    case rateLimited(retryAfter: TimeInterval?)
    case underlying(code: Int?, message: String)

    /// Backwards-compatibility helper for older call sites expecting `AuthError.unknown(error:)`.
    public static func unknown(error: Error) -> AuthError {
        let ns = error as NSError
        return .underlying(code: ns.code, message: ns.localizedDescription)
    }

    /// A generic unknown error value.
    public static var unknown: AuthError { .underlying(code: nil, message: "An unknown error occurred.") }
}

extension AuthError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "The email or password you entered is incorrect."
        case .userNotFound:
            return "No account was found for this identifier."
        case .emailAlreadyInUse:
            return "That email address is already in use."
        case .weakPassword:
            return "Your password is too weak. Please choose a stronger one."
        case .unauthorized:
            return "You are not authorized to perform this action."
        case .sessionExpired:
            return "Your session has expired. Please sign in again."
        case .network:
            return "A network error occurred. Please check your connection and try again."
        case .cancelled:
            return "The operation was cancelled."
        case .rateLimited(let retryAfter):
            if let retryAfter {
                return "Too many attempts. Try again in \(Int(retryAfter)) seconds."
            } else {
                return "Too many attempts. Please try again later."
            }
        case .underlying(_, let message):
            return message
        }
    }
}

/// Convenience helpers for building and mapping authentication errors.
public enum AuthErrors {
    /// Maps a generic error (e.g., from networking or backend) to an `AuthError`.
    /// You can expand the mapping logic to fit your backend/service codes.
    public static func map(_ error: Error) -> AuthError {
        // If it's already an AuthError, return it directly
        if let auth = error as? AuthError { return auth }

        // Try to downcast to NSError to inspect codes/domains
        let ns = error as NSError
        let code = ns.code
        let domain = ns.domain

        // Example heuristics; adjust to your backend or provider (e.g., Firebase, custom API)
        switch (domain, code) {
        case (NSURLErrorDomain, NSURLErrorNotConnectedToInternet),
             (NSURLErrorDomain, NSURLErrorTimedOut),
             (NSURLErrorDomain, NSURLErrorNetworkConnectionLost):
            return .network
        case (_, 401):
            return .unauthorized
        case (_, 404):
            return .userNotFound
        case (_, 409):
            return .emailAlreadyInUse
        case (_, 429):
            // If server provides retry-after in userInfo, try to use it
            let retryAfter = ns.userInfo["Retry-After"] as? TimeInterval
            return .rateLimited(retryAfter: retryAfter)
        default:
            // Preserve the original message if any
            let message = ns.localizedDescription
            return .underlying(code: code, message: message)
        }
    }

    /// Creates a user-friendly error from an optional error.
    /// If `error` is nil, returns a generic network error by default.
    public static func map(_ error: Error?) -> AuthError {
        guard let error else { return .network }
        return map(error)
    }

    /// A generic catch-all error for unexpected states.
    public static var unknown: AuthError { .underlying(code: nil, message: "An unknown error occurred.") }
}

