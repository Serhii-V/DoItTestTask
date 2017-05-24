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

        // Do any additional setup after loading the view.
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
                    if code == 200 {
                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn") // save our state
                        UserDefaults.standard.synchronize()
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        self.errorLabel.isHidden = false
                    }
                }
            }
            
            
            
//            let parameters = ["email":"\(emailTextField.text!)", "password":"\(passwordTextField.text!)"]
//            
//            guard let url = URL(string:"http://api.doitserver.in.ua/login") else {return}
//            
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
//                return
//            }
//            
//            request.httpBody = httpBody
//            let session = URLSession.shared
//            print(request)
//            session.dataTask(with: request) { (data, response, error) in
//                if let response = response {
//                    print("resp = \(response) ========")
//                    print(response)
//                }
//                if let data = data {
//                    do {
//                        let json = try JSONSerialization.jsonObject(with: data, options: [])
//                        print(json)
//                        // add check for response 200
//                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
//                        UserDefaults.standard.synchronize()
//                        self.dismiss(animated: true, completion: nil)
//                        
//                    } catch {
//                        print(error)
//                    }
//                }
//                }.resume()
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
