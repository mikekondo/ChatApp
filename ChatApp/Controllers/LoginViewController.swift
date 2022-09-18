//
//  LoginViewController.swift
//  ChatApp
//
//  Created by 近藤米功 on 2022/09/18.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var dontHaveAccountButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didTapDontHaveAccountButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func didTapLoginButton(_ sender: Any) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("ログインに失敗しました",error)
                return
            }
            print("ログインに成功しました")

            // chatListViewControllerのfetchChatRoomsInfoFromFirestoreを呼ぶ
            let nav = self.presentingViewController as! UINavigationController
            let chatListViewController = nav.viewControllers[nav.viewControllers.count - 1] as? ChatListViewController
            chatListViewController?.fetchChatRoomsInfoFromFirestore()
            self.dismiss(animated: true,completion: nil)
        }
    }


}
