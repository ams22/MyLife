//
//  GlobalStorage.swift
//  MyLife
//
//  Created by Андрей Решетников on 01.05.16.
//  Copyright © 2016 mipt. All rights reserved.
//

import Foundation

struct GlobalStorage {
    static var token = ""
    static var userID = ""
    static var answerTuple = ([String: String](), UIImage())
    //"56820028"
    static var myImageData = NSData()
    static var checkValidNotFoundImage = false
    
    static var userEmail = ""
}