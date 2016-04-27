//
//  PhotoTableViewCell.swift
//  MyLife
//
//  Created by Андрей Решетников on 27.04.16.
//  Copyright © 2016 mipt. All rights reserved.
//

import Foundation
import UIKit

class PhotoTableViewCell: UITableViewCell, ImageOperationProtocol {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    var imageDownloader: ImageDownloader!
    var imageRecord: ImageRecord!
    var imageRenderer: ImageRenderer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.accessoryView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    }
    
    override func prepareForReuse() {
        self.prerapeForNewImage()
    }
    
    func prerapeForNewImage() {
        if (self.imageRecord.state == .Downloading) {
            self.imageDownloader.cancelDownloading(self.imageRecord.path)
        }
        self.imageRecord.state = .NotDownloaded
        self.photoImageView.image = nil
        self.imageRecord = nil
    }
    
    func startUpdatingCell(imagePath: String) {
        startDownloadingIndicator()
        self.imageDownloader = ImageDownloader(delegate: self)
        self.imageRenderer = ImageRenderer(delegate: self)
        self.imageRecord = ImageRecord(path: imagePath)
        self.imageDownloader.downloadImageRecord(self.imageRecord)
    }
    
    func startDownloadingIndicator() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let indicator = self.accessoryView as! UIActivityIndicatorView
        indicator.startAnimating()
    }
    
    func stopDownloadingIndicator() {
        let indicator = self.accessoryView as! UIActivityIndicatorView
        indicator.stopAnimating()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}

extension PhotoTableViewCell {
    func fetchedImageRecord(imageRecord: ImageRecord) {
        switch imageRecord.state {
        case .Downloaded:
            let width = self.frame.width
            let height = self.frame.height
            self.imageRenderer.renderImage(imageRecord, targetSize: CGSize(width: width, height: height))
            break
        case .Rendered:
            stopDownloadingIndicator()
            self.photoImageView.image = imageRecord.imageSmall
            if (self.window?.rootViewController?.isKindOfClass(PhotoTableViewController) != nil) {
//                let parentVC = self.window?.rootViewController as! PhotoTableViewController
//                let indexPath = parentVC.photoTableView.indexPathForCell(self)
//                if (indexPath != nil) {
//                    print("Adding to ", terminator: "")
//                    print(indexPath!.row)
//                    PhotoTableViewController.downloadedImages[indexPath!] = imageRecord
//                }
            }
            break
        default:
            print("Error with fetching an image record")
        }
    }
}