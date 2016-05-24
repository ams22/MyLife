//
//  VKAuthorizationTableViewController.swift
//  MyLife
//
//  Created by Андрей Решетников on 01.05.16.
//  Copyright © 2016 mipt. All rights reserved.
//

import Foundation
import AFNetworking
import UIKit
import VK_ios_sdk

class VKAuthorizationTableViewController: UITableViewController {
    
    let scope = [VK_PER_WALL, VK_PER_PHOTOS, VK_PER_AUDIO, VK_PER_EMAIL]
    
    @IBOutlet weak var id: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var surname: UITextField!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var next: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.next.enabled = false
        self.avatar.image = nil
        authorizedConnect()
        getPhoto()
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    func authorizedConnect() {
        VKSdk.wakeUpSession(scope, completeBlock: { state, error in
            if (state == VKAuthorizationState.Authorized) {
                print(VKSdk.accessToken().accessToken)
                GlobalStorage.userEmail = VKSdk.accessToken().email
                let request: VKRequest = VKApi.requestWithMethod("users.get", andParameters: ["fields":"photo_400_orig"])
                request.executeWithResultBlock(
                    {response in
                        print(response.json)
                        if let respon = response.json as? NSArray,
                            let dict = respon[0] as? NSDictionary {
                                self.id.text = String(dict["id"] as! Int)
                                GlobalStorage.userID = String(dict["id"] as! Int)
                                self.name.text = dict["first_name"] as? String
                                self.surname.text = dict["last_name"] as? String
                                //let networkHelper = NetworkHelper()
                                //networkHelper.getImageWithURL((dict["photo_400_orig"] as? String)!)
                                self.next.enabled = true
                                let url = NSURL(string: String(dict["photo_400_orig"]!))
                                self.getDataFromUrl(url!) { (data, response, error)  in
                                    self.avatar.image = UIImage(data: data!)
                                }
                        } else {
                            print("Json crush")
                        }
                    }, errorBlock: {error in
                        print(error)
                })
            } else if (error != nil) {
             print(error)
            }
        })
    }
    
    func getPhoto() {
        let request: VKRequest = VKApi.requestWithMethod("newsfeed.get", andParameters: ["owner_id": "56820028", "filters": "photo", "max_photos": "100", "count": "100"])
        request.executeWithResultBlock(
            {response in
                //print(response.json)
                var str: String = ""
                let respon = response.json["items"] as! NSArray
                for item in respon {
                    let photos = item["photos"]
                    let it = photos!!["items"] as! NSArray
                    for i in it {
                        print(i["photo_604"])
                        if let photo_url = i["photo_604"] {
                            //self.imagesLinks.append(photo_url as! String)
                            str = str + (photo_url as! String) + " "
                            print(photo_url as! String)
                        }
                    }
                }
                self.writeToFile(str)
            }, errorBlock: {error in
                print(error)
        })
    }
    
    func writeToFile(str: String) {
        let filePath = NSHomeDirectory() + "/Library/Caches/test.txt"
        print(filePath)
        do {
            _ = try str.writeToFile(filePath, atomically: true, encoding: NSUTF8StringEncoding)
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 0) {
            switch (indexPath.item) {
                case 4:
                    let secondStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                    let next = secondStoryBoard.instantiateViewControllerWithIdentifier("SWReveal") as! SWRevealViewController
                    self.presentViewController(next, animated: true, completion: nil)
                    break
                default:
                    break
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}