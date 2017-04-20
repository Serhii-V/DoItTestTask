//
//  WorkWithAPI.swift
//  DoItTestTask
//
//  Created by Serhii on 4/20/17.
//  Copyright © 2017 Serhii. All rights reserved.
//

import UIKit

class WorkWithAPI: NSObject {
    
    static func fetchData(feed:String,token:String? = nil,parameters:[String:AnyObject]? = nil,method:String? = nil, onCompletion:@escaping (_ success:Bool,_ data:NSDictionary?)->Void){
        
        DispatchQueue.main.async() {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            let url = NSURL(string: feed)
            if let unwrapped_url = NSURL(string: feed){
                
                let request = NSMutableURLRequest(url: unwrapped_url as URL)
                
                if let tk = token {
                    let authValue = "Token \(tk)"
                    request.setValue(authValue, forHTTPHeaderField: "Authorization")
                }
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                if let parm = parameters{
//                    if let data = NSJSONSerialization.dataWithJSONObject(parm, options:NSJSONWritingOptions(0), error:nil) as NSData? {
//                        
//                        //println(NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: nil))
//                        request.HTTPBody = data
//                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//                        request.setValue("\(data.length)", forHTTPHeaderField: "Content-Length")
//                    }
                    print("parm")
                }
                
                if let unwrapped_method = method {
                    request.httpMethod = unwrapped_method
                }
                
                let sessionConfiguration = URLSessionConfiguration.default
                sessionConfiguration.timeoutIntervalForRequest = 15.0
                let session = URLSession(configuration: sessionConfiguration)
                let taskGetCategories = session.dataTask(with: request as URLRequest){ (responseData, response, error) -> Void in
                    
                    
                    
                    let statusCode = (response as! HTTPURLResponse?)?.statusCode
                    //println("Status Code: \(statusCode), error: \(error)")
                    if error != nil || (statusCode != 200 && statusCode != 201 && statusCode != 202){
                        onCompletion(false, nil)
                        
                    }
                    else {
                        //var e: NSError?
//                        if let dictionary = JSONSerialization.JSONObjectWithData(responseData, options: .MutableContainers | .AllowFragments, error: nil) as? NSDictionary{
//                            onCompletion(success:true,data:dictionary)
//                            
//                        }
//                        else{
//                            onCompletion(false, nil)
//                        }
                    }
                }
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                taskGetCategories.resume()
            }
        }
    }

}
