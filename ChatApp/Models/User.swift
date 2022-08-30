//
//  User.swift
//  ChatApp
//
//  Created by 近藤米功 on 2022/08/30.
//

import Foundation
import Firebase

class User {
    let email: String
    let userName: String
    let createdAt: Timestamp
    let profileImageUrl: String

    init(dic: [String: Any]) {
        self.email = dic["email"] as? String ?? ""
        self.userName = dic["userName"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
        self.profileImageUrl = dic["profileImageUrl"] as? String ?? ""
    }
}
