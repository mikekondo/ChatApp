//
//  Storage.swift
//  ChatApp
//
//  Created by 近藤米功 on 2022/09/19.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore

class StorageImage {

    func registerUserToFirestore(profileImage: Data,userName: String,email: String,password: String) async throws {
        let fileName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("profile_image").child(fileName)
        do{
            let data = try await storageRef.putDataAsync(profileImage)
            let url = try await storageRef.downloadURL()
            try await Auth.createUserToFireAuth(profileImage: url.absoluteString, userName: userName, email: email, password: password)
        }
        catch{
            print("どこかでエラー",error)
        }
    }
}
