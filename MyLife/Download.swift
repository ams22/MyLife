//
//  Download.swift
//  MyLife
//
//  Created by Андрей Решетников on 22.05.16.
//  Copyright © 2016 mipt. All rights reserved.
//

import Foundation
import UIKit

class Download: NSObject {
    
    var url: String
    var isDownloading = false
    
    var downloadTask: NSURLSessionDownloadTask?
    
    init(url: String) {
        self.url = url
    }
}