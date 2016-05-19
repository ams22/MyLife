//
//  AboutDataSource.swift
//  MyLife
//
//  Created by Андрей Решетников on 20.05.16.
//  Copyright © 2016 mipt. All rights reserved.
//

import Foundation

class AboutDataSource: NSObject {
    var usernames: NSArray = []
    var avatarNames: NSArray = []
    var text: NSString = ""
    
    override init() {
        usernames = ["Andrey", "Reshetnikov"]
        avatarNames = ["epc-62e740A", "hqdefault", "I7HCbsqZt3Y-2"]
        text = "МФТИ, ФИВТ, 3-ий курс, ios developer, c/c++ developer, beginner of data science, github.com/hoderu"
    }
    
    func randomPost() -> About {
        let username: NSString = self.usernames[Int(arc4random()) % self.usernames.count] as! NSString
        let avatar = UIImage(named: self.avatarNames[Int(arc4random()) % self.avatarNames.count] as! String)
        return About(_username: username, _avatar: avatar!, _text: text)
    }
}