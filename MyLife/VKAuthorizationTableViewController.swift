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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(VKAuthorizationTableViewController.updateImageFromVK), name: "imageFromVKWithoutToken", object: nil)
        self.next.enabled = false
        self.avatar.image = nil
        authorizedConnect()
    }
    
    func authorizedConnect() {
        VKSdk.wakeUpSession(scope, completeBlock: { state, error in
            if (state == VKAuthorizationState.Authorized) {
                print(VKSdk.accessToken().accessToken)
                //let request: VKRequest = VKApi.requestWithMethod("audio.get", andParameters: ["owner_id": "56820028", "count": "3"])
                let request: VKRequest = VKApi.requestWithMethod("users.get", andParameters: ["fields":"photo_400_orig"])
                request.executeWithResultBlock(
                    {response in
                        print(response.json)
                        if let respon = response.json as? NSArray,
                            let dict = respon[0] as? NSDictionary {
                                self.id.text = String(dict["id"] as! Int)
                                self.name.text = dict["first_name"] as? String
                                self.surname.text = dict["last_name"] as? String
                                let networkHelper = NetworkHelper()
                                networkHelper.getImageWithURL((dict["photo_400_orig"] as? String)!)
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateImageFromVK() {
        self.avatar.image = UIImage(data: GlobalStorage.myImageData)
        self.next.enabled = true
    }
    
}