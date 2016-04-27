//
//  ImageDownloadingOperation.swift
//  MyLife
//
//  Created by Андрей Решетников on 27.04.16.
//  Copyright © 2016 mipt. All rights reserved.
//

import Foundation

class ImageDownloadingOperation: NSOperation {
    
    let imageRecord : ImageRecord
    
    init(imageRecord: ImageRecord) {
        self.imageRecord = imageRecord
    }
    
    override func main() {
        if (self.cancelled) {
            return
        }
        
        let imageData = NSData(contentsOfURL: NSURL(string: imageRecord.path)!)
        
        if (!self.cancelled) {
            if (imageData != nil) {
                self.imageRecord.image = UIImage(data: imageData!)
                self.imageRecord.state = ImageState.Downloaded
            } else {
                self.imageRecord.image = nil
                self.imageRecord.state = ImageState.Failed
            }
        }
    }
}