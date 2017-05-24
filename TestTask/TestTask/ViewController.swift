//
//  ViewController.swift
//  TestTask
//
//  Created by Serhii on 5/11/17.
//  Copyright © 2017 SERHII. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
    
    @IBAction func logOutButton(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        self.performSegue(withIdentifier: "signinView", sender: self)
    }
    
    
}

 
