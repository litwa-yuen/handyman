//
//  LoginType.swift
//  handyman
//
//  Created by Lit Wa Yuen on 11/12/25.
//

enum LoginType: String {
    case email
    case apple
    case google
    case facebook
    
    var iconName: String {
        switch self {
        case .email:
            return "envelope.fill"
        case .apple:
            return "apple.fill"
        case .google:
            return "google"
        case .facebook:
            return "facebook"
        }
    }
    
    var title: String {
        switch self {
        case .email:
            return "Continue With Email"
        case .apple:
            return "Continue With Apple"
        case .google:
            return "Continue With Google"
        case .facebook:
            return "Continue With Facebook"
        }
    }
}
