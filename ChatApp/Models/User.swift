//
//  User.swift
//  ChatApp
//
//  Created by 近藤米功 on 2022/08/30.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct User: Codable {
    public var id = UUID().uuidString
    let email: String
    let userName: String
    let createdAt: Timestamp
    let profileImageUrl: String

    var uid: String?

    init(dic: [String: Any]) {
        self.email = dic["email"] as? String ?? ""
        self.userName = dic["userName"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
        self.profileImageUrl = dic["profileImageUrl"] as? String ?? ""
    }
}
