//
//  UserListTableViewCell.swift
//  ChatApp
//
//  Created by 近藤米功 on 2022/08/31.
//

import UIKit
import SDWebImage

class UserListTableViewCell: UITableViewCell {

    var user: User? {
        didSet {
            guard let user = user else { return }
            userNameLabel.text = user.userName
            userImageView.sd_setImage(with: URL(string: user.profileImageUrl))
        }
    }

    var chatroom: ChatRoom? {
        didSet {
        }
    }
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!

    static let identifier = "UserListCell"
    static let nibName = "UserListTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
    }
    
}
