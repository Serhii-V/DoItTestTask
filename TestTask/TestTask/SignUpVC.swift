//
//  SignUpVC.swift
//  TestTask
//
//  Created by Serhii on 5/12/17.
//  Copyright © 2017 SERHII. All rights reserved.
//

import UIKit
import Alamofire

class SignUpVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        avatarView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeAvatar(_ sender: UIButton) {
        
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        
        present(controller, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func signUpButton(_ sender: UIButton) {
        let username = usernameTextField.text
        let email = emailTextField.text
        let password = passwordTextField.text
        let confirm = confirmPasswordTextField.text
        let image = avatarView.image!
        
        
        if (username == ""  || email == "" || password == "" || confirm == "" ) {
            errorLabel.text = "check data"
            errorLabel.textColor = UIColor.red
            errorLabel.isHidden = false
        } else if (password != confirm) {
            errorLabel.text = "wrong confirmation "
            errorLabel.textColor = UIColor.red
            errorLabel.isHidden = false
            
        } else {

            let parameters = ["username":"\(username!)","email":"\(email!)", "password":"\(password!)"]
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                if let imageData = UIImageJPEGRepresentation(image, 1) {
                    multipartFormData.append(imageData, withName: "avatar", fileName: "file.png", mimeType: "image/png")
                }
                
                for (key, value) in parameters {
                    multipartFormData.append((value.data(using: .utf8))!, withName: key)
                }}, to: "http://api.doitserver.in.ua/create", method: .post,
                    encodingCompletion: { encodingResult in
                        switch encodingResult {
                        case .success(let upload, _, _):
                            upload.response { [weak self] response in
                                guard self != nil else {
                                    return
                                }
                                if response.response?.statusCode == 201 {
                                    self?.dismiss(animated: true, completion: nil)
                                }
                                
                            }
                        case .failure(let encodingError):
                            print("error:\(encodingError)")
                        }
            })
        } 
    }
}
