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
    
    func getUserInfoWithoutToken(userID: String, token: String, completion: () -> Void) {
        sessionManager = AFHTTPSessionManager()
        sessionManager.requestSerializer = AFJSONRequestSerializer()
        sessionManager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        loginUrlTail = "https://api.vk.com/method/users.get?user_id=\(userID)&fields=photo_400_orig&v=5.52&access_token=\(token)"
        sessionManager.POST(loginUrlTail, parameters: [], progress: nil, success: { (sessionDataTask, response) in
            print("JSON response is \(response!)")
            
            var result = [String]()
            var keys = [String]()
            if let theJSON = response as? NSDictionary,
                let respon = theJSON["response"] as? NSArray,
                 let responElement = respon[0] as? NSDictionary {
                    for iter in responElement.allValues {
                        result.append("\(iter)")
                    }
                    for iter in responElement.allKeys {
                        keys.append("\(iter)")
                    }
            } else {
                print("Json crush")
            }
            
            if ((keys.indexOf("id")) != nil) {
                //GlobalStorage.answerTuple.0["id"] = result[keys.indexOf("id")!]
            } else {
                //GlobalStorage.answerTuple.0["id"] = "Not found"
            }
            if (keys.indexOf("first_name") != nil) {
                //GlobalStorage.answerTuple.0["first_name"] = result[keys.indexOf("first_name")!]
            } else {
                //GlobalStorage.answerTuple.0["first_name"] = "Not found"
            }
            if ((keys.indexOf("last_name")) != nil) {
                //GlobalStorage.answerTuple.0["last_name"] = result[keys.indexOf("last_name")!]
            } else {
                //GlobalStorage.answerTuple.0["last_name"] = "Not found"
            }
            if ((keys.indexOf("photo_400_orig")) != nil) {
                let networkHelper = NetworkHelper()
                networkHelper.getImageWithURL(result[keys.indexOf("photo_400_orig")!])
            } else {
                //GlobalStorage.answerTuple.1 = UIImage(named: "notFound")!
                //GlobalStorage.checkValidNotFoundImage = true
            }
            completion()
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