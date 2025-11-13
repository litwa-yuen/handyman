//
//  UserInfo.swift
//  handyman
//
//  Created by Lit Wa Yuen on 11/13/25.
//
import FirebaseAuth

struct UserInfo: Codable {
    let uid: String
    let email: String?
    let displayName: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.displayName = user.displayName
    }
}
