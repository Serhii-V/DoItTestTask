//
//  SignUpVC.swift
//  TestTask
//
//  Created by Serhii on 5/12/17.
//  Copyright © 2017 SERHII. All rights reserved.
//

import UIKit
import Alamofire

class SignUpVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var addImageScrollV: UIScrollView!
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
    
    var activeTextField:UITextField?;
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addImageScrollV.setContentOffset(CGPoint.init(x: 0, y: 20), animated: true)
        activeTextField = textField;
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        addImageScrollV.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        activeTextField = nil;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
//        if textField.tag == 0 {
//            descriptionTF.becomeFirstResponder()
//        } else {
//            descriptionTF.resignFirstResponder()
//        }
        return true
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
                if let imageData = UIImageJPEGRepresentation(image, 0.5) {
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
                                self?.navigationController?.popViewController(animated: true)
                                } else {
                                    print((response.response?.statusCode)!)
                                }
                                print(response.response!)
                            }
                        case .failure(let encodingError):
                            print("error:\(encodingError)")
                        }
            })
        } 
    }
    
}
