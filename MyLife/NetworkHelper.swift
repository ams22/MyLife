//
//  NetworkHelper.swift
//  MyLife
//
//  Created by Андрей Решетников on 12.05.16.
//  Copyright © 2016 mipt. All rights reserved.
//

import Foundation

class NetworkHelper: NSObject {
    
    struct SessionProperties {
        static let identifier: String! = "url_session_background_download"
    }
    
    var delegate = DownloadSessionDelegate.sharedInstance
    
    func getImageWithURL(imageURL: String) {
        let configuration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(SessionProperties.identifier)
        let backgroundSession = NSURLSession(configuration: configuration, delegate: self.delegate, delegateQueue: nil)
        let url = NSURLRequest(URL: NSURL(string: imageURL)!)
        let downloadTask = backgroundSession.downloadTaskWithRequest(url)
        downloadTask.resume()
    }
}