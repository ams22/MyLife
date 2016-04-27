//
//  ImageRenderer.swift
//  MyLife
//
//  Created by Андрей Решетников on 27.04.16.
//  Copyright © 2016 mipt. All rights reserved.
//

import Foundation
import UIKit

class ImageRenderer: ImageOperator {
    static var renderingQueue = NSOperationQueue()
    
    func renderImage(imageRecord: ImageRecord, targetSize: CGSize) {
        imageRecord.state = .Rendering
        let renderingOperation = ImageRenderingOperation(imageRecord: imageRecord, targetSize: targetSize)
        
        renderingOperation.completionBlock = {
            if (renderingOperation.cancelled) {
                return
            }
            let mainQueue = NSOperationQueue.mainQueue()
            mainQueue.addOperationWithBlock({
                imageRecord.state = .Rendered
                self.delegate.fetchedImageRecord(imageRecord)
            })
        }
        
        ImageRenderer.pendingOperations[imageRecord.path] = renderingOperation
        ImageRenderer.renderingQueue.addOperation(renderingOperation)
    }
    
    func cancelRendering(path: String) {
        ImageRenderer.pendingOperations[path]?.cancel()
        ImageRenderer.pendingOperations.removeValueForKey(path)
    }
}