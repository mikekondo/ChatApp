//
//  Firebase-Extension.swift
//  ChatApp
//
//  Created by 近藤米功 on 2022/09/19.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

extension Auth {
    static func createUserToFireAuth(profileImage: String,userName: String,email: String,password: String) async throws {
        do{
            try await Auth.auth().createUser(withEmail: email, password: password)
            try await Firestore.setUserDataToFirestore(profileImage: profileImage, userName: userName, email: email)
            print("ユーザ情報の登録に成功")
        }catch{
            print("ユーザ情報の登録に失敗",error)
        }
    }

}

extension Firestore {
    static func setUserDataToFirestore(profileImage: String,userName: String,email: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let docData = ["profileImageUrl": profileImage,
                       "userName": userName,
                       "email": email,
                       "createdAt": Timestamp()] as [String : Any]
        try await Firestore.firestore().collection("Users").document(uid).setData(docData)
        
    }
}
