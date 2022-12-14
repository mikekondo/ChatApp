//
//  ChatListTableViewCell.swift
//  ChatApp
//
//  Created by 近藤米功 on 2022/08/28.
//

import UIKit
import SDWebImage

class ChatListTableViewCell: UITableViewCell {

    var chatroom: ChatRoom? {
        didSet {
            guard let chatroom = chatroom else { return }
            partnerLabel.text = chatroom.partnerUser?.userName
            userImageView.sd_setImage(with: URL(string: chatroom.partnerUser?.profileImageUrl ?? ""))
            dateLabel.text = dateFormatterForDateLabel(date: chatroom.createdAt.dateValue())
        }
    }

    static let identifier = "ChatListCell"
    static let nibName = "ChatListTableViewCell"

    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var latestMessageLabel: UILabel!
    @IBOutlet private weak var partnerLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // 円形にする
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
    }

    private func dateFormatterForDateLabel(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
    
}
