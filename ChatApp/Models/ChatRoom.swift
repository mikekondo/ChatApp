//
//  ChatRoom.swift
//  ChatApp
//
//  Created by 近藤米功 on 2022/08/31.
//

import Foundation
import Firebase

class ChatRoom {
    let latestMessageId: String
    let members: [String]
    let createdAt: Timestamp

    var partnerUser: User?

    init(dic: [String: Any]) {
        self.latestMessageId = dic["latestMessageId"] as? String ?? ""
        self.members = dic["members"] as? [String] ?? [String]()
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
    }
}
