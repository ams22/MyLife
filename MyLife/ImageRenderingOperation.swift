//
//  ImageRenderingOperation.swift
//  MyLife
//
//  Created by Андрей Решетников on 27.04.16.
//  Copyright © 2016 mipt. All rights reserved.
//

import Foundation
import UIKit

class ImageRenderingOperation: NSOperation {
    
    let imageRecord: ImageRecord
    let targetSize: CGSize
    
    init(imageRecord: ImageRecord, targetSize: CGSize) {
        self.imageRecord = imageRecord
        self.targetSize = targetSize
    }
    
    override func main() {
        if (!self.cancelled) {
            imageRecord.state = .Rendering
            UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0)
            imageRecord.image?.drawInRect(CGRectMake(0, 0, targetSize.width, targetSize.height))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            imageRecord.imageSmall = newImage
            imageRecord.state = .Rendered
        }
    }
}