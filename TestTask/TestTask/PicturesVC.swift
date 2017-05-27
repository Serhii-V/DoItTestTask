//
//  PicturesVC.swift
//  TestTask
//
//  Created by Serhii on 5/26/17.
//  Copyright © 2017 SERHII. All rights reserved.
//

import UIKit
import Alamofire
import Foundation
import SwiftGifOrigin

class PicturesVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let reuseIdentifier = "cell"
    var imagesData:[ImageData]? = []
    
    @IBOutlet var picturesCollectionView: UICollectionView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        var width = UIScreen.main.bounds.width
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        width = width - 10
        layout.itemSize = CGSize(width: (width / 2) - 30, height: (width / 2) - 30)
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        picturesCollectionView!.collectionViewLayout = layout
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.imagesData?.count) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! PicturesCVCCell
        
        cell.picrureCellImage?.dowloadImage(url: (self.imagesData?[indexPath.item].smalImagePath!)!)
        cell.picrureCellAddress.text = self.imagesData?[indexPath.item].address
        cell.picrureCellWeather.text = self.imagesData?[indexPath.item].weather
        
       // self.picturesCollectionView.reloadData()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "BigImageVC") as! BigImageVC
        
        // un first i  used big image path but i caught server error on 70 % of images {"error":{"code":404,"message":"Not Found"}}  http://api.doitserver.in.ua/upload/images/big/9af2fd6c26d7f7927df1d17c5f16c98c.jpeg
        
//        if let str = (self.imagesData?[indexPath.item].bigImagePath) {
//            imageBigStr = str
//        }
        
        if let str = (self.imagesData?[indexPath.item].smalImagePath) {
            myVC.image = str
        }
        
        if let desc = (self.imagesData?[indexPath.item].imageDescription) {
           myVC.imageDescription = desc
        } else {
            myVC.imageDescription  = "No description"
        }
        
        if let hash = (self.imagesData?[indexPath.item].hashtag) {
          myVC.hashtag = hash
        } else {
            myVC.hashtag = "No hashtag"
        }
        
        
        
        navigationController?.pushViewController(myVC, animated: true)
       // self.performSegue(withIdentifier: "BigImageVC", sender: self)
        print ("You selected cell #\(indexPath.item)!")
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        UserDefaults.standard.synchronize()
        self.navigationController?.popViewController(animated: true)
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
                        if  imageDataFromImages.count != 0 {
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
                        }
                        DispatchQueue.main.async {
                            self.picturesCollectionView.reloadData()
                        }
                        
                    } catch let error {
                        print(error)
                    }
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    @IBAction func showGif(_ sender: UIBarButtonItem) {
        let imageView = UIImageView()

        

            if let token = UserDefaults.standard.value(forKey: "token") {
                let urlString = "http://api.doitserver.in.ua/gif"
                let header: HTTPHeaders = [
                    "token": "\(token)"]
                Alamofire.request(urlString, headers: header).responseJSON { response in
                    
                    if let data = response.result.value {
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                            let json = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! [String:String]
                                DispatchQueue.main.async {
                                    let gifStr = json["gif"]!
                                    let imageV = UIImageView()
                                    
                                    
                                    let urlRequest = URLRequest(url: URL(string: gifStr)!)
                                    let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                                        if error != nil {
                                            print(error)
                                        }
                                        DispatchQueue.main.async {
                                            imageV.image = UIImage.gif(data: data!)
                                            imageV.frame = CGRect(x: 50, y: 100, width: 250, height: 250)
                                            self.view.addSubview(imageV)
                                        }
                                    }
                                    task.resume()
                            }
                        } catch let error {
                            print(error)
                        }
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

