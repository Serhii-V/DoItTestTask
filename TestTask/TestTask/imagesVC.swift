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

class imagesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var imagesData:[ImageData]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! ImageCell
        cell.firstColAdress.text = self.imagesData?[indexPath.item].address
        cell.firstColWeather.text = self.imagesData?[indexPath.item].weather
        cell.imageView?.dowloadImage(url: (self.imagesData?[indexPath.item].smalImagePath!)!)
        
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.imagesData?.count ?? 0
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
                if let data = response.result.value {
                    
                    self.imagesData = [ImageData]()
                    
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                        let json = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! [String:AnyObject]
                        if let imageDataFromImages = json["images"] as? [[String: AnyObject]] {
                            
                            var imageData = ImageData()
                            
                            for data in imageDataFromImages {
                                //print(data)
                                if let smallImagePath = data["smallImagePath"] as? String {
                                    imageData.smalImagePath = smallImagePath
                                    //print(smallImagePath)
                                }
                                if let bigImagePath = data["bigImagePath"] as? String {
                                    imageData.bigImagePath = bigImagePath
                                    //print(bigImagePath)
                                }
                                if let idImage = "\(data["id"])" as? String {
                                    imageData.id = idImage
                                    //print(idImage)
                                }
                                if let hashtag = data["hashtag"] as? String {
                                    imageData.hashtag = hashtag
                                    //print(hashtag)
                                }
                                if let created = data["created"] as? String {
                                    imageData.created = created
                                    //print(created)
                                }
                                if let description = data["description"] as? String {
                                    imageData.imageDescription = description
                                    //print(description)
                                }
                                
                                if let parameters = data["parameters"] as? [String:Any] {
                                    for (key, value) in parameters {
                                        if key == "latitude" {
                                            imageData.latitude = "\(value)"
                                            //print(value)
                                        }
                                        if key == "longitude" {
                                            imageData.longitude = "\(value)"
                                            // print(value)
                                        }
                                        if key == "weather" {
                                            imageData.weather = "\(value)"
                                            //print(value)
                                        }
                                        if key == "address" {
                                            imageData.address = "\(value)"
                                            //print(value)
                                        }
                                        
                                        
                                    }
                                }
                                
                                self.imagesData?.append(imageData)
                                imageData = ImageData()
                                
                                //print(imageData.smalImagePath)
                            }
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                    } catch let error {
                        print(error)
                    }
                    //print(jsonData)
                }
            }
        }
        
        
    }
    
    
}



extension UIImageView {
    
    
    func dowloadImage(url: String){
        let urlRequest = URLRequest(url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            if error != nil {
                print(error)
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
                
            }
            
        }
        task.resume()
    }
}
