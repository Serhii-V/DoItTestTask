//
//  imagesVC.swift
//  TestTask
//
//  Created by Serhii on 5/24/17.
//  Copyright © 2017 SERHII. All rights reserved.
//

import UIKit
import Alamofire
import Foundation

class imagesVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !(UserDefaults.standard.bool(forKey: "isUserLoggedIn")) {
            self.performSegue(withIdentifier: "signinView", sender: self)
        }
        
        
    }

    @IBAction func logout(_ sender: UIBarButtonItem) {
    UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
    UserDefaults.standard.synchronize()
    self.performSegue(withIdentifier: "signinView", sender: self)
    }
    
    func getData() {
        if let token = UserDefaults.standard.value(forKey: "token") {
            let urlString = "http://api.doitserver.in.ua/all"
            let header: HTTPHeaders = [
                "token": "\(token)"]
            
            Alamofire.request(urlString, headers: header).responseJSON { response in
                debugPrint(response.result.value)
            }
        }
        
        
    }
    

}
