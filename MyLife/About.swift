//
//  About.swift
//  MyLife
//
//  Created by Андрей Решетников on 20.05.16.
//  Copyright © 2016 mipt. All rights reserved.
//

import Foundation

class About: NSObject {
    
    var username: NSString = ""
    var avatar: UIImage
    var text: NSString = ""
    
    init(_username: NSString, _avatar: UIImage, _text: NSString) {
        username = _username
        avatar = _avatar
        text = _text
    }
    
}