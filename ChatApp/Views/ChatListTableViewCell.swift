//
//  ChatListTableViewCell.swift
//  ChatApp
//
//  Created by 近藤米功 on 2022/08/28.
//

import UIKit

class ChatListTableViewCell: UITableViewCell {

    var user: User? {
        didSet {
            partnerLabel.text = user?.userName
            // userImageView.image = user?.profileImageUrl
            dateLabel.text = user?.createdAt.dateValue().description
            latestMessageLabel.text = user?.email
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
        userImageView.layer.cornerRadius = userImageView.frame.height/2
    }
    
}
