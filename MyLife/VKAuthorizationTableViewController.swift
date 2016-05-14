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

class VKAuthorizationTableViewController: UITableViewController {
    
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
        openVK()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openVK() {
        let network = networkVKGetUserInfoWithoutToken()
        network.getUserInfoWithoutToken(GlobalStorage.userID, token: GlobalStorage.token, completion: {
            self.id.text = GlobalStorage.answerTuple.0["id"]
            self.name.text = GlobalStorage.answerTuple.0["first_name"]
            self.surname.text = GlobalStorage.answerTuple.0["last_name"]
            if GlobalStorage.checkValidNotFoundImage {
                self.avatar.image = GlobalStorage.answerTuple.1
                self.next.enabled = true
            }
        })
    }
    
    func updateImageFromVK() {
        self.avatar.image = UIImage(data: GlobalStorage.myImageData)
        self.next.enabled = true
    }
}