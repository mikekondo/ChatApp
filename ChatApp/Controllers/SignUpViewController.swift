//
//  SignUpViewController.swift
//  ChatApp
//
//  Created by 近藤米功 on 2022/08/29.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import PKHUD

class SignUpViewController: UIViewController {

    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var alreadyHaveAccountButton: UIButton!

    let storageImage = StorageImage()


    override func viewDidLoad() {
        super.viewDidLoad()

        profileImageButton.layer.cornerRadius = profileImageButton.frame.size.height/2

        profileImageButton.layer.borderWidth = 1
        profileImageButton.layer.borderColor = UIColor.rgb(red: 240, green: 240, blue: 240).cgColor

        registerButton.isEnabled = false

        emailTextField.delegate = self
        passwordTextField.delegate = self
        userNameTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = true
    }

    @IBAction func didTapProfileImageButton(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true, completion: nil)
    }

    @IBAction func didTapRegisterButton(_ sender: Any) {
        guard let image = profileImageButton.imageView?.image else { return }
        guard let uploadImage = image.jpegData(compressionQuality: 0.3) else { return }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let userName = userNameTextField.text else { return }
        HUD.show(.progress)
        Task{
            do{
                try await storageImage.registerUserToFirestore(profileImage: uploadImage, userName: userName, email: email, password: password)
                HUD.hide()
                self.dismiss(animated: true)
            }catch {
                print("ユーザ情報の登録に失敗",error)
            }
        }
    }

    @IBAction func didTapAlreadyHaveAccountButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }

    private func createUserToFirestore(profileImageUrl: String){
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error{
                print("認証情報の保存に失敗しました",error)
                HUD.hide()
                return
            }
            print("認証情報の保存に成功しました")
            guard let uid = result?.user.uid else { return }
            guard let userName = self.userNameTextField.text else { return }
            let docData = ["email": email,
                           "userName": userName,
                           "createdAt": Timestamp(),
                           "profileImageUrl": profileImageUrl] as [String : Any]
            Firestore.firestore().collection("Users").document(uid).setData(docData) { error in
                if let error = error {
                    print("Firestoreへの情報の保存に失敗",error)
                    HUD.hide()
                    return
                }
                print("Firestoreへの情報の保存に成功")
                HUD.hide()
                self.dismiss(animated: true,completion: nil)
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}

// MARK: - UITextViewDelegate
extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let emailIsEmpty = emailTextField.text?.isEmpty ?? false
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? false
        let userNameIsEmpty = userNameTextField.text?.isEmpty ?? false
        if emailIsEmpty || passwordIsEmpty || userNameIsEmpty {
            registerButton.isEnabled = false
        }else {
            registerButton.isEnabled = true
        }
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // サイズの変えた時と変えてない時
        if let editImage = info[.editedImage] as? UIImage{
            profileImageButton.setImage(editImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info[.originalImage] as? UIImage {
            profileImageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }

        profileImageButton.setTitle("", for: .normal)
        profileImageButton.imageView?.contentMode = .scaleAspectFill
        profileImageButton.contentHorizontalAlignment = .fill
        profileImageButton.contentVerticalAlignment = .fill
        profileImageButton.clipsToBounds = true

        dismiss(animated: true,completion: nil)
    }

}
