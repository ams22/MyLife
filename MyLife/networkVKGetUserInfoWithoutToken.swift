//
//  networkVKGetUserInfoWithoutToken.swift
//  MyLife
//
//  Created by Андрей Решетников on 10.05.16.
//  Copyright © 2016 mipt. All rights reserved.
//

import Foundation
import UIKit
import AFNetworking

class networkVKGetUserInfoWithoutToken {
   var sessionManager: AFHTTPSessionManager!
    
    //ID APP 5442423
    var loginUrlTail = ""
    let getTokenURL = "https://oauth.vk.com/authorize?client_id=5442423&scope=status&redirect_uri=http://oauth.vk.com/blank.html&display=mobile&response_type=token"
    //let getPhotosURL = "https://api.vk.com/method/photos.get?user_id=56820028&album_id=profile&v=5.52&access_token=\(token)"
    
    func getUserInfoWithoutToken() {
        sessionManager = AFHTTPSessionManager()
        sessionManager.requestSerializer = AFJSONRequestSerializer()
        sessionManager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        loginUrlTail = "https://api.vk.com/method/users.get?user_id=\(GlobalStorage.userID)&fields=photo_400_orig&v=5.52&access_token=\(GlobalStorage.token)"
        sessionManager.POST(loginUrlTail, parameters: [], progress: nil, success: { (sessionDataTask, response) in
            print("JSON response is \(response!)")
            
            let theJSON = response as! NSDictionary
            let respon = theJSON["response"] as! NSArray
            let responElement = respon[0] as! NSDictionary
            var result = [String]()
            for iter in responElement.allValues {
                result.append("\(iter)")
            }
            var keys = [String]()
            for iter in responElement.allKeys {
                keys.append("\(iter)")
            }
            
            if ((keys.indexOf("id")) != nil) {
                GlobalStorage.answerTuple.0["id"] = result[keys.indexOf("id")!]
            } else {
                GlobalStorage.answerTuple.0["id"] = "Not found"
            }
            if (keys.indexOf("first_name") != nil) {
                GlobalStorage.answerTuple.0["first_name"] = result[keys.indexOf("first_name")!]
            } else {
                GlobalStorage.answerTuple.0["first_name"] = "Not found"
            }
            if ((keys.indexOf("last_name")) != nil) {
                GlobalStorage.answerTuple.0["last_name"] = result[keys.indexOf("last_name")!]
            } else {
                GlobalStorage.answerTuple.0["last_name"] = "Not found"
            }
            if ((keys.indexOf("photo_400_orig")) != nil) {
                let imageData = NSData(contentsOfURL: NSURL(string: result[keys.indexOf("photo_400_orig")!])!)
                let image = UIImage(data: imageData!)
                GlobalStorage.answerTuple.1 = image!
            } else {
                GlobalStorage.answerTuple.1 = UIImage(named: "notFound")!
            }
            NSNotificationCenter.defaultCenter().postNotificationName("gotUserInfoVKRegistrationWithoutToken", object: self)
            }, failure: { (sessionDataTask, error) in
                print(error)
        })
    }
    
    /*func getToken() {
     sessionManager = AFHTTPSessionManager()
     sessionManager.requestSerializer = AFJSONRequestSerializer()
     sessionManager.responseSerializer = AFHTTPResponseSerializer()
     sessionManager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
     sessionManager.responseSerializer.acceptableContentTypes = NSSet(objects: "text/html") as! Set<String>
     sessionManager.POST(getTokenURL, parameters: [], progress: nil, success: { (sessionDataTask, response) in
     print("JSON response is \(response!)")
     
     let result = NSString(data: response as! NSData, encoding: NSUTF8StringEncoding)!
     print(result)
     let urlRequest = NSMutableURLRequest()
     
     }, failure: { (sessionDataTask, error) in
     print(error)
     })
     }*/
    
}