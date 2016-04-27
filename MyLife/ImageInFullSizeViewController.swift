//
//  ImageInFullSizeViewController.swift
//  MyLife
//
//  Created by Андрей Решетников on 27.04.16.
//  Copyright © 2016 mipt. All rights reserved.
//

import Foundation
import UIKit

class ImageInFullSizeViewController: UIViewController, ImageOperationProtocol {
    
    @IBOutlet weak var imageInFullSize: UIImageView!
    
    var imageRenderer : ImageRenderer!
    var imageRecord : ImageRecord!
    
    override func viewWillAppear(animated: Bool) {
        self.imageRenderer = ImageRenderer(delegate: self)
        self.imageRenderer.renderImage(imageRecord, targetSize: imageInFullSize.frame.size)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ImageInFullSizeViewController {
    func fetchedImageRecord(imageRecord: ImageRecord) {
        imageInFullSize.image = imageRecord.image
    }
}