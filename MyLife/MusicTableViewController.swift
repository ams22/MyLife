//
//  MusicViewController.swift
//  MyLife
//
//  Created by Андрей Решетников on 26.04.16.
//  Copyright © 2016 mipt. All rights reserved.
//

import Foundation
import UIKit
import AFNetworking
import MediaPlayer
import VK_ios_sdk

class MusicTableViewController: UIViewController, NSURLSessionDelegate {
    
    let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    var dataTask: NSURLSessionDataTask?
    var activeDownloads = [String: Download]()
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var searchResults = [Track]()
    var userID = ""
    
    lazy var downloadsSession: NSURLSession = {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        return session
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //-----------------------COLORS------------------------------------------
        self.view.backgroundColor = uicolorFromHex(0xffff00)
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        self.navigationController?.navigationBar.barTintColor = uicolorFromHex(0x670067)
        //-----------------------------------------------------------------------
        if self.revealViewController() != nil {
            menuButton.tintColor = UIColor.whiteColor()
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        if (userID == "") {
            let alert = UIAlertController(title: "Вы не залогинились через вк", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            let actionOk = UIAlertAction(title: "Хорошо", style: UIAlertActionStyle.Default, handler: nil)
            alert.addAction(actionOk)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        tableView.tableFooterView = UIView()
        self.updateSearchResults()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateSearchResults() {
        searchResults.removeAll()
        let request: VKRequest = VKApi.requestWithMethod("audio.get", andParameters: ["owner_id": userID, "count": "100"])
        request.executeWithResultBlock(
            {response in
                print(response.json)
                let respon = response.json["items"] as! NSArray
                print(respon)
                for item in respon {
                    print(item)
                    let name = item["title"] as! String
                    let artist = item["artist"] as! String
                    let url = item["url"] as! String
                    self.searchResults.append(Track(name: name, artist: artist, previewUrl: url))
                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                    self.tableView.setContentOffset(CGPointZero, animated: false)
                }
            }, errorBlock: {error in
                print(error)
        })
    }
    
    func trackIndexForDownloadTask(downloadTask: NSURLSessionDownloadTask) -> Int? {
        if let url = downloadTask.originalRequest?.URL?.absoluteString {
            for (index, track) in searchResults.enumerate() {
                if url == track.previewUrl! {
                    return index
                }
            }
        }
        return nil
    }
    
    func startDownload(track: Track) {
        if let urlString = track.previewUrl, url =  NSURL(string: urlString) {
            let download = Download(url: urlString)
            download.downloadTask = downloadsSession.downloadTaskWithURL(url)
            download.downloadTask!.resume()
            download.isDownloading = true
            activeDownloads[download.url] = download
        }
    }
    
    func playDownload(track: Track) {
        if let urlString = track.previewUrl, url = localFilePathForUrl(urlString) {
            let moviePlayer:MPMoviePlayerViewController! = MPMoviePlayerViewController(contentURL: url)
            presentMoviePlayerViewControllerAnimated(moviePlayer)
        }
    }
    
    func localFilePathForUrl(previewUrl: String) -> NSURL? {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        if let url = NSURL(string: previewUrl), lastPathComponent = url.lastPathComponent {
            let fullPath = documentsPath.stringByAppendingPathComponent(lastPathComponent)
            return NSURL(fileURLWithPath: fullPath)
        }
        return nil
    }
    
    func localFileExistsForTrack(track: Track) -> Bool {
        if let urlString = track.previewUrl, localUrl = localFilePathForUrl(urlString) {
            var isDir : ObjCBool = false
            if let path = localUrl.path {
                return NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory: &isDir)
            }
        }
        return false
    }
}

extension MusicTableViewController: NSURLSessionDownloadDelegate {
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        if let originalURL = downloadTask.originalRequest?.URL?.absoluteString,
            destinationURL = localFilePathForUrl(originalURL) {
            print(destinationURL)
            
            let fileManager = NSFileManager.defaultManager()
            do {
                try fileManager.removeItemAtURL(destinationURL)
            } catch let error {
                print(error)
            }
            do {
                try fileManager.copyItemAtURL(location, toURL: destinationURL)
            } catch let error as NSError {
                print("Could not copy file to disk: \(error.localizedDescription)")
            }
        }
        
        if let url = downloadTask.originalRequest?.URL?.absoluteString {
            activeDownloads[url] = nil
            if let trackIndex = trackIndexForDownloadTask(downloadTask) {
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: trackIndex, inSection: 0)], withRowAnimation: .None)
                })
            }
        }
    }
}

extension MusicTableViewController: TrackCellDelegate {
    func downloadTapped(cell: TrackCell) {
        if let indexPath = tableView.indexPathForCell(cell) {
            let track = searchResults[indexPath.row]
            startDownload(track)
            tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: 0)], withRowAnimation: .None)
        }
    }
}

extension MusicTableViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TrackCell", forIndexPath: indexPath) as!TrackCell
        cell.delegate = self
        let track = searchResults[indexPath.row]
        cell.titleLabel.text = track.name
        cell.artistLabel.text = track.artist
        
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = uicolorFromHex(0xffff00)
            cell.titleLabel.textColor = UIColor.blackColor()
            cell.artistLabel.textColor = UIColor.blackColor()
        } else {
            cell.backgroundColor = uicolorFromHex(0x670067)
            cell.titleLabel.textColor = UIColor.whiteColor()
            cell.artistLabel.textColor = UIColor.whiteColor()
        }
        
        let downloaded = localFileExistsForTrack(track)
        cell.selectionStyle = downloaded ? UITableViewCellSelectionStyle.Gray : UITableViewCellSelectionStyle.None
        cell.downloadButton.hidden = downloaded
        
        return cell
    }
}

extension MusicTableViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 62.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let track = searchResults[indexPath.row]
        if localFileExistsForTrack(track) {
            playDownload(track)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

