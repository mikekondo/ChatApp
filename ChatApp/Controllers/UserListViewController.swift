//
//  UserListViewController.swift
//  ChatApp
//
//  Created by 近藤米功 on 2022/08/31.
//

import UIKit
import Firebase
import FirebaseFirestore

class UserListViewController: UIViewController {

    @IBOutlet weak var userListTableView: UITableView!
    @IBOutlet weak var startChatButton: UIBarButtonItem!

    private var users = [User]()
    private var selectedUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        startChatButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUserInfoFromFirestore()
    }

    private func fetchUserInfoFromFirestore() {
        Firestore.firestore().collection("Users").getDocuments { snapShots, error in
            if let error = error {
                print("ユーザ情報の取得に失敗",error)
                return
            }
            snapShots?.documents.forEach({ snapShot in
                let data = snapShot.data()
                var user = User(dic: data)
                user.uid = snapShot.documentID
                // 自分は表示しない // snapShot.documentIDでドキュメントIDを取得できる
                guard let uid = Auth.auth().currentUser?.uid else { return }
                if uid == snapShot.documentID {
                    return
                }
                self.users.append(user)
                self.userListTableView.reloadData()
            })
        }
    }

    private func setupTableView(){
        userListTableView.delegate = self
        userListTableView.dataSource = self
        userListTableView.register(UINib(nibName: UserListTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: UserListTableViewCell.identifier)
    }


    @IBAction func didStartChatButton(_ sender: Any) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let partnerUid = self.selectedUser?.uid else { return }
        let members = [uid, partnerUid]
        let docData = ["members": members,"latestMessageId": "",
                       "createdAt": Timestamp()] as [String : Any]

        Firestore.firestore().collection("ChatRooms").document().setData(docData) { error in
            if let error = error {
                print("ChatRoom情報の保存に失敗しました",error)
            }
            print("ChatRoom情報の保存に成功しました")
            self.dismiss(animated: true)
        }
    }

    @IBAction func didTapCloseButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserListTableViewCell.identifier, for: indexPath) as! UserListTableViewCell
        cell.user = users[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        startChatButton.isEnabled = true
        let user = users[indexPath.row]
        self.selectedUser = user
    }
}
