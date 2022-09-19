//
//  ChatInputAccessoryView.swift
//  ChatApp
//
//  Created by 近藤米功 on 2022/08/29.
//

import UIKit

import UIKit

protocol ChatInputAccessoryViewDelegate: class {
    func tappedSendButton(text: String)
}

class ChatInputAccessoryView: UIView {
    // MARK: - UI Parts
    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!

    weak var delegate: ChatInputAccessoryViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        nibInit()
        setupViews()
        autoresizingMask = .flexibleHeight
    }

    private func setupViews() {
        chatTextView.layer.cornerRadius = 15
        chatTextView.layer.borderColor = UIColor.rgb(red: 230, green: 230, blue: 230).cgColor
        chatTextView.layer.borderWidth = 1
        sendButton.layer.cornerRadius = 15
        sendButton.isEnabled = false

        // chatTextViewの初期状態を空にする
        chatTextView.text = ""

        chatTextView.delegate = self
    }

    override var intrinsicContentSize: CGSize {
        return .zero
    }

    func removeText(){
        chatTextView.text = ""
        sendButton.isEnabled = false
    }

    // ChatInputAccessoryView.xibに貼り付け
    private func nibInit() {
        let nib = UINib(nibName: "ChatInputAccessoryView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(view)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func didTapSendButton(_ sender: Any) {
        guard let text = chatTextView.text else { return }
        delegate?.tappedSendButton(text: text)
    }

}

// MARK: - UITextViewDelegate
extension ChatInputAccessoryView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            sendButton.isEnabled = false
        }else{
            sendButton.isEnabled = true
        }
    }
}
