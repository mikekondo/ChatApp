//
//  ChatListViewController.swift
//  ChatApp
//
//  Created by 近藤米功 on 2022/08/28.
//

import UIKit
import Firebase

class ChatListViewController: UIViewController {

    @IBOutlet weak var chatListTableView: UITableView!

    private var chatrooms = [ChatRoom]()
    private var chatRoomListener: ListenerRegistration? // fetchChatRoomsInfoFromFirestoreが二重で呼ばれることを防ぐ

    private var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupChatListTableView()
        setupNavigationBar()
        confirmLoggedInUser()
        fetchChatRoomsInfoFromFirestore()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchLoginUserInfo()
    }

    @IBAction private func didTapNewChatButton(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "UserList", bundle: nil)
        let userListViewController = storyboard.instantiateViewController(withIdentifier: "UserListViewController")
        let nav = UINavigationController(rootViewController: userListViewController)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true,completion: nil)
    }

    @IBAction private func didTapLogoutButton(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
            let signUpViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController")
            let nav = UINavigationController(rootViewController: signUpViewController)
            self.present(nav,animated: true,completion: nil)
        }catch{
            print("ログアウトに失敗しました",error)
        }
    }
    func fetchChatRoomsInfoFromFirestore() {
        chatRoomListener?.remove()
        chatrooms.removeAll()
        print("chatroomsのカウント",chatrooms.count)
        chatRoomListener = Firestore.firestore().collection("ChatRooms")
            .addSnapshotListener { snapShots, error in
                if let error = error {
                    print("ChatRoom情報の取得に失敗",error)
                    return
                }
                // 新しくきた情報を受け取る（※最初に実行した時点では、実行したクエリに該当するデータの全てが取得されます）
                snapShots?.documentChanges.forEach({ documentChange in
                    switch documentChange.type {
                    case .added:
                        self.handleAddedDocumentChange(documentChange: documentChange)
                    case .modified:
                        print("nothing to do")
                    case .removed:
                        print("nothing to do")
                    }
                })
            }
    }

    private func handleAddedDocumentChange(documentChange: DocumentChange) {
        let data = documentChange.document.data()
        let chatroom = ChatRoom(dic: data)
        chatroom.documentId = documentChange.document.documentID
        guard let uid = Auth.auth().currentUser?.uid else { return }

        // membersにuidが含まれていたらisContainはtrueになる、含まれていないならfalseになる
        let isContain = chatroom.members.contains(uid)
        // 含まれてないならなにもせずリターン
        if !isContain { return }

        chatroom.members.forEach { memberUid in
            if memberUid != uid {
                Firestore.firestore().collection("Users").document(memberUid).getDocument { snapShot, error in
                    if let error = error {
                        print("ユーザ情報の取得に失敗しました",error)
                        return
                    }
                    guard let data = snapShot?.data() else { return }
                    var user = User(dic: data)
                    user.uid = memberUid
                    chatroom.partnerUser = user
                    self.chatrooms.append(chatroom)
                    self.chatListTableView.reloadData()
                }
            }
        }
    }

    private func confirmLoggedInUser() {
        // auth情報がないならサインアップ画面に遷移
        if Auth.auth().currentUser?.uid == nil {
            let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
            let signUpViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
            let nav = UINavigationController(rootViewController: signUpViewController)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }

    private func setupChatListTableView() {
        chatListTableView.delegate = self
        chatListTableView.dataSource = self
        chatListTableView.register(UINib(nibName: ChatListTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: ChatListTableViewCell.identifier)
    }

    private func setupNavigationBar(){
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .rgb(red: 39, green: 49, blue: 69) // 黒っぽいグレー
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.title = "トーク"
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    private func fetchLoginUserInfo() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("Users").document(uid).getDocument { snapShot, error in
            if let error = error {
                print("ユーザ情報の取得に失敗しました",error)
            }
            guard let snapShot = snapShot else { return }
            guard let data = snapShot.data() else { return }
            let user = User(dic: data)
            self.navigationItem.title = user.userName
            self.user = user
        }
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ChatListViewController: UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatrooms.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = chatListTableView.dequeueReusableCell(withIdentifier: ChatListTableViewCell.identifier, for: indexPath) as? ChatListTableViewCell else {
            fatalError("cellの作成に失敗")
        }
        cell.chatroom = chatrooms[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "ChatRoom", bundle: nil)
        let chatRoomViewController = storyboard.instantiateViewController(withIdentifier: "ChatRoomViewController") as! ChatRoomViewController
        // chatRoomの情報を渡す（目的：ChatRoomのドキュメントID取得のため）
        chatRoomViewController.chatRoom = chatrooms[indexPath.row]
        chatRoomViewController.user = user
        navigationController?.pushViewController(chatRoomViewController, animated: true)
    }
}
