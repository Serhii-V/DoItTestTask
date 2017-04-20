//
//  ViewController.swift
//  DoItTestTask
//
//  Created by Serhii on 4/20/17.
//  Copyright © 2017 Serhii. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        WorkWithAPI.fetchData(feed: "http://api.doitserver.in.ua", token: nil, parameters: nil, method: "POST", onCompletion: {(success, data) -> Void in
            if success {
            print("Bingo")
            } })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

