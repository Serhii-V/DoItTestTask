//
//  SignInVC.swift
//  TestTask
//
//  Created by Serhii on 5/12/17.
//  Copyright © 2017 SERHII. All rights reserved.
//

import UIKit
import Alamofire

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        if (UserDefaults.standard.bool(forKey: "isUserLoggedIn")) {
            self.performSegue(withIdentifier: "picturesVC", sender: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        errorLabel.isHidden = true
    }
    
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func signInButton(_ sender: UIButton) {
        if dataIsOk() {
            let parameters = ["email":"\(emailTextField.text!)", "password":"\(passwordTextField.text!)"]
            guard let url = URL(string:"http://api.doitserver.in.ua/login") else {return}
            Alamofire.request(url, method: .post , parameters: parameters).responseJSON { response in
                if let code = response.response?.statusCode {
                    print(code)
                    if code == 200 {
                        var token = String()
                        let array = response.description.components(separatedBy: ";")
                        for i in array {
                            if i.contains("token") {
                                let temp = i.components(separatedBy: " ")
                                token = temp[temp.count - 1]
                                print(token)
                            }
                        }
                        UserDefaults.standard.set(token, forKey: "token")
                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn") // save our state
                        UserDefaults.standard.synchronize()
                        self.performSegue(withIdentifier: "picturesVC", sender: self)
                    } else {
                        self.errorLabel.isHidden = false
                    }
                }
            }
        } else
        {
            errorLabel.isHidden = false // if empty field, show the message
        }
    }
    
    func dataIsOk() -> Bool  {    // Check for empty fields. I
        if emailTextField.text == "" || passwordTextField.text == "" {
            return false
        } else {
            return true
        }
        // add more check like ( "@" and "." )
    }
}
