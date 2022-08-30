//
//  ChatRoomViewController.swift
//  ChatApp
//
//  Created by 近藤米功 on 2022/08/28.
//

import UIKit

class ChatRoomViewController: UIViewController {

    @IBOutlet weak var chatRoomTableView: UITableView!
    private var messages = [String]()

    private lazy var chatInputAccessoryView: ChatInputAccessoryView = {
        let view = ChatInputAccessoryView()
        view.frame = .init(x: 0, y: 0, width: view.frame.width, height: 100)
        view.delegate = self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupChatRoomTableView()
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
        messages.append(text)
        chatInputAccessoryView.removeText()
        chatRoomTableView.reloadData()
        print("text:",text)
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
        cell.messageTextView.text = messages[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 最低基準の高さを設定
        chatRoomTableView.estimatedRowHeight = 20
        return UITableView.automaticDimension // messageTextViewを基準にしてTableViewの高さが決まる
    }


}
