//
//  AppStateViewModel.swift
//  handyman
//
//  Created by Lit Wa Yuen on 11/13/25.
//
import Foundation
import SwiftUI
import Combine

@MainActor
final class AppStateViewModel: ObservableObject {
    @Published var currentUser: UserInfo? = nil
    
    init() {
        self.currentUser = AuthenicationManager.shared.getLoggedInUser()
    }
    
    func signOut() throws {
        try AuthenicationManager.shared.signOut()
        self.currentUser = nil
    }
    
    func isLoggedIn() -> Bool {
        self.currentUser != nil
    }
}
