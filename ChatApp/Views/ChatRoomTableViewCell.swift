//
//  ChatRoomTableViewCell.swift
//  ChatApp
//
//  Created by 近藤米功 on 2022/08/28.
//

import UIKit

class ChatRoomTableViewCell: UITableViewCell {

    static let identifier = "ChatRoomCell"
    static let nibName = "ChatRoomTableViewCell"

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        userImageView.layer.cornerRadius = userImageView.frame.height/2
        messageTextView.layer.cornerRadius = 15

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func estimateFrameForTextView(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
    }

    func configure(){
        
    }
    
}
