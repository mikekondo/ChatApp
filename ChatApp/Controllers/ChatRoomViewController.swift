//
//  ChatRoomViewController.swift
//  ChatApp
//
//  Created by 近藤米功 on 2022/08/28.
//

import UIKit
import Firebase

class ChatRoomViewController: UIViewController {

    @IBOutlet weak var chatRoomTableView: UITableView!
    private var messages = [Message]()
    var chatRoom: ChatRoom?
    var user: User?

    private lazy var chatInputAccessoryView: ChatInputAccessoryView = {
        let view = ChatInputAccessoryView()
        view.frame = .init(x: 0, y: 0, width: view.frame.width, height: 100)
        view.delegate = self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupChatRoomTableView()
        fetchMessages()
    }

    // inputAccessoryViewのセット
    override var inputAccessoryView: UIView? {
        get{
            return chatInputAccessoryView
        }
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    private func fetchMessages() {
        guard let chatroomDocId = chatRoom?.documentId else { return }
        Firestore.firestore().collection("ChatRooms").document(chatroomDocId).collection("messages").addSnapshotListener { snapShots, error in
            if let error = error {
                print("メッセージ情報の取得に失敗しました",error)
                return
            }
            snapShots?.documentChanges.forEach({ documentChange in
                switch documentChange.type {
                case .added:
                    let data = documentChange.document.data()
                    let message = Message(dic: data)
                    self.messages.append(message)
                    self.chatRoomTableView.reloadData()

                case .modified:
                    print("none")
                case .removed:
                    print("none")
                }
            })
        }
    }



    private func setupChatRoomTableView() {
        chatRoomTableView.delegate = self
        chatRoomTableView.dataSource = self
        chatRoomTableView.register(UINib(nibName: ChatRoomTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: ChatRoomTableViewCell.identifier)
        chatRoomTableView.backgroundColor = .rgb(red: 118, green: 140, blue: 180)
    }

}

// MARK: - ChatInputAccessoryViewDelegate
extension ChatRoomViewController: ChatInputAccessoryViewDelegate{
    func tappedSendButton(text: String) {

        guard let chatroomDocId = chatRoom?.documentId else { return }

        guard let name = user?.userName else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        chatInputAccessoryView.removeText()

        let docData = ["name": name,"createdAt": Timestamp(),"uid": uid,"message": text] as [String : Any]
        Firestore.firestore().collection("ChatRooms").document(chatroomDocId).collection("messages").document().setData(docData) { error in
            if let error = error {
                print("メッセージ情報の保存に失敗しました",error)
            }
            print("メッセージの保存に成功しました")
        }
    }
}

// MARK: - UITableViewDelegate,UITableViewDataSource
extension ChatRoomViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = chatRoomTableView.dequeueReusableCell(withIdentifier: ChatRoomTableViewCell.identifier, for: indexPath) as? ChatRoomTableViewCell else{
            fatalError("cell error")
        }
        cell.message = messages[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 最低基準の高さを設定
        chatRoomTableView.estimatedRowHeight = 20
        return UITableView.automaticDimension // messageTextViewを基準にしてTableViewの高さが決まる
    }


}
