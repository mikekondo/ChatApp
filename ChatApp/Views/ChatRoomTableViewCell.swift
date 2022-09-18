//
//  ChatRoomTableViewCell.swift
//  ChatApp
//
//  Created by 近藤米功 on 2022/08/28.
//

import UIKit
import FirebaseAuth
import SDWebImage

class ChatRoomTableViewCell: UITableViewCell {

    var message: Message? {
        didSet {
//            guard let message = message else { return }
//            partnerMessageTextView.text = message.message
//            partnerDateLabel.text = dateFormatterForDateLabel(date: message.createdAt.dateValue())
        }
    }

    static let identifier = "ChatRoomCell"
    static let nibName = "ChatRoomTableViewCell"

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var partnerMessageTextView: UITextView!
    @IBOutlet weak var partnerDateLabel: UILabel!
    @IBOutlet weak var myMessageTextView: UITextView!
    @IBOutlet weak var myDateLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        userImageView.layer.cornerRadius = userImageView.frame.height/2
        partnerMessageTextView.layer.cornerRadius = 15
        myMessageTextView.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkWhichUserMessage()
    }

    private func checkWhichUserMessage() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        if uid == message?.uid {
            partnerMessageTextView.isHidden = true
            partnerDateLabel.isHidden = true
            userImageView.isHidden = true
            myMessageTextView.isHidden = false
            myDateLabel.isHidden = false

            guard let message = message else { return }
            myMessageTextView.text = message.message
            myDateLabel.text = dateFormatterForDateLabel(date: message.createdAt.dateValue())
        }else{
            partnerMessageTextView.isHidden = false
            partnerDateLabel.isHidden = false
            userImageView.isHidden = false
            myMessageTextView.isHidden = true
            myDateLabel.isHidden = true


            guard let message = message else { return }
            partnerMessageTextView.text = message.message
            partnerDateLabel.text = dateFormatterForDateLabel(date: message.createdAt.dateValue())
            userImageView.sd_setImage(with: URL(string: message.partnerUser?.profileImageUrl ?? ""))
        }
    }

    private func estimateFrameForTextView(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
    }

    private func dateFormatterForDateLabel(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
}
