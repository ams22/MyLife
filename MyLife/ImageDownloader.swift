//
//  ImageDownloader.swift
//  MyLife
//
//  Created by Андрей Решетников on 27.04.16.
//  Copyright © 2016 mipt. All rights reserved.
//

import Foundation
import UIKit

class ImageDownloader: ImageOperator {
    
    static var downloadedQueue = NSOperationQueue()
    
    func downloadImageRecord(imageRecord: ImageRecord) {
        imageRecord.state = .Downloading
        let downloadingOperation = ImageDownloadingOperation(imageRecord: imageRecord)
        
        downloadingOperation.completionBlock = {
            if (downloadingOperation.cancelled) {
                return
            }
            let mainQueue = NSOperationQueue.mainQueue()
            mainQueue.addOperationWithBlock({ 
                imageRecord.state = .Downloaded
                self.delegate.fetchedImageRecord(imageRecord)
            })
        }
        
        ImageDownloader.pendingOperations[imageRecord.path] = downloadingOperation
        ImageDownloader.downloadedQueue.addOperation(downloadingOperation)
    }
    
    func cancelDownloading(path: String) {
        ImageDownloader.pendingOperations[path]?.cancel()
        ImageDownloader.pendingOperations.removeValueForKey(path)
    }
}