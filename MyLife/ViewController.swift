//
//  ViewController.swift
//  MyLife
//
//  Created by Андрей Решетников on 21.04.16.
//  Copyright © 2016 mipt. All rights reserved.
//

import UIKit
import VK_ios_sdk

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        VKSdk.initializeWithAppId("5442423")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

