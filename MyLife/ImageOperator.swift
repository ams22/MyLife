//
//  ImageOperator.swift
//  MyLife
//
//  Created by Андрей Решетников on 27.04.16.
//  Copyright © 2016 mipt. All rights reserved.
//

import Foundation
import UIKit

class ImageOperator: NSObject {
    
    let delegate: ImageOperationProtocol!
    static var pendingOperations = [String : NSOperation]()
    
    init (delegate: ImageOperationProtocol!) {
        self.delegate = delegate
    }
}
