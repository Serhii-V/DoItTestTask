//
//  SignUpVC.swift
//  TestTask
//
//  Created by Serhii on 5/12/17.
//  Copyright © 2017 SERHII. All rights reserved.
//

import UIKit

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
    
    @IBAction func singInButton(_ sender: UIButton) {
        let username = usernameTextField.text
        let email = emailTextField.text
        let password = passwordTextField.text
        let confirm = confirmPasswordTextField.text
        let image = UIImageJPEGRepresentation(avatarView.image!, 1)
        if (username == ""  || email == "" || password == "" || confirm == "" ) {
            errorLabel.text = "check data"
            errorLabel.textColor = UIColor.red
            errorLabel.isHidden = false
        } else if (password != confirm) {
            errorLabel.text = "wrong confirmation "
            errorLabel.textColor = UIColor.red
            errorLabel.isHidden = false

        } else {
            let parameters = ["username":"\(username)","email":"\(email)", "password":"\(password)"] as [String : Any]
            
            guard let url = URL(string:"http://api.doitserver.in.ua/create") else {return}
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
                return
            }
            
            request.httpBody = httpBody
            let session = URLSession.shared
            print(request)
            session.dataTask(with: request) { (data, response, error) in
                if let response = response {
                    print(response)
                }
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print(json)
                    } catch {
                        print(error)
                    }
                }
                }.resume()
        }
        
        
    }
    


}
