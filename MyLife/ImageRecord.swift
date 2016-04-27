//
//  ImageRecord.swift
//  MyLife
//
//  Created by Андрей Решетников on 27.04.16.
//  Copyright © 2016 mipt. All rights reserved.
//

import Foundation
import UIKit

class ImageRecord {
    var path  : String
    var state : ImageState = .NotDownloaded
    var image : UIImage? = UIImage(named: "No image")
    var imageSmall : UIImage? = UIImage(named: "No big image")
    
    init() {
        self.path = ""
    }
    
    init(path : String) {
        self.path = path
    }
}