//
//  BigImageVC.swift
//  TestTask
//
//  Created by Serhii on 5/26/17.
//  Copyright © 2017 SERHII. All rights reserved.
//

import UIKit

class BigImageVC: UIViewController {
    
    @IBOutlet weak var bigImageInNewVC: UIImageView!
    @IBOutlet weak var imageDescriptionInNewVC: UILabel!
    @IBOutlet weak var imageHeshtagInNewVC: UILabel!
    
    var image = String()
    var imageDescription = String()
    var hashtag = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        bigImageInNewVC.dowloadImage(url: image)
        imageDescriptionInNewVC.text = imageDescription
        imageHeshtagInNewVC.text = hashtag
        print(image)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
