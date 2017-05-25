//
//  addImageVC.swift
//  TestTask
//
//  Created by Serhii on 5/24/17.
//  Copyright © 2017 SERHII. All rights reserved.
//

import UIKit
import Alamofire

class addImageVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    @IBOutlet weak var ScrollViewContainer: UIScrollView!
    @IBOutlet weak var descriptionTF: UITextField!
    @IBOutlet weak var hashtagTF: UITextField!
    @IBOutlet weak var latitudeTF: UITextField!
    @IBOutlet weak var longitudeTF: UITextField!
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var activeTextField:UITextField?;
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        ScrollViewContainer.setContentOffset(CGPoint.init(x: 0, y: 250), animated: true)
        activeTextField = textField;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        ScrollViewContainer.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        activeTextField = nil;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.tag == 0 {
            descriptionTF.becomeFirstResponder()
        } else {
            descriptionTF.resignFirstResponder()
        }
        return true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imagePreview.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImageButton(_ sender: UIButton) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        
        present(controller, animated: true, completion: nil)
        
    }
    
    @IBAction func uploadButton(_ sender: UIButton) {
        let description = descriptionTF.text
        let hashtag = hashtagTF.text
        let latitude = latitudeTF.text
        let longitude = longitudeTF.text
        let image = imagePreview.image!
        let token = UserDefaults.standard.value(forKey: "token")!
        
        if (description == ""  || hashtag == "" || latitude == "" || longitude == "" ) {
            errorLabel.isHidden = false
        } else {
            
            let parameters = ["description":"\(description!)","hashtag":"\(hashtag!)", "latitude":"\(latitude!)", "longitude" : "\(longitude!)"]
            
        
            Alamofire.upload(multipartFormData:{ multipartFormData in
                let imageData = UIImageJPEGRepresentation(image, 0.2)
                multipartFormData.append(imageData!, withName: "image", fileName: "file.png", mimeType: "image/png")
                for (key, value) in parameters {
                    multipartFormData.append((value.data(using: .utf8))!, withName: key)
                }
            },
                             
                             to:"http://api.doitserver.in.ua/image",
                             method:.post,
                             headers:["token": "\(token)"],
                             encodingCompletion: { encodingResult in
                                switch encodingResult {
                                case .success(let upload, _, _):
                                    upload.responseJSON { response in
                                        if (response.response?.statusCode) == 201 {
                                          self.navigationController?.popViewController(animated: true)
                                        }
                                        debugPrint(response.response?.statusCode)
                                    }
                                case .failure(let encodingError):
                                    print(encodingError)
                                }
            })
        }
    }
}
