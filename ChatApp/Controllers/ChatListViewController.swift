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

    private var user: User? {
        didSet {
            navigationItem.title = user?.userName
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupChatListTableView()
        setupNavigationBar()
        confirmLoggedInUser()
        fetchLoginUserInfo()
    }

    @IBAction func didTapNewChatButton(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "UserList", bundle: nil)
        let userListViewController = storyboard.instantiateViewController(withIdentifier: "UserListViewController")
        let nav = UINavigationController(rootViewController: userListViewController)
        self.present(nav, animated: true,completion: nil)
    }

    private func confirmLoggedInUser() {
        // auth情報がないならサインアップ画面に遷移
        if Auth.auth().currentUser?.uid == nil {
            let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
            let signUpViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
            signUpViewController.modalPresentationStyle = .fullScreen
            self.present(signUpViewController, animated: true, completion: nil)
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
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = chatListTableView.dequeueReusableCell(withIdentifier: ChatListTableViewCell.identifier, for: indexPath) as? ChatListTableViewCell else {
            fatalError("cellの作成に失敗")
        }
        // cell.user = users[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "ChatRoom", bundle: nil)
        let chatRoomViewController = storyboard.instantiateViewController(withIdentifier: "ChatRoomViewController")
        navigationController?.pushViewController(chatRoomViewController, animated: true)
    }
}
