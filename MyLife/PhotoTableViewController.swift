//
//  PhotoTableViewController.swift
//  MyLife
//
//  Created by Андрей Решетников on 26.04.16.
//  Copyright © 2016 mipt. All rights reserved.
//

import Foundation
import UIKit

class PhotoTableViewController: UITableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var imagesLinks: [String] = []
    var imageDownloader: ImageDownloader!
    static var downloadedImages = [NSIndexPath : ImageRecord]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        let path = NSBundle.mainBundle().pathForResource("downloadingList", ofType: "txt")
        self.imagesLinks = (try! String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)).componentsSeparatedByString("\n")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imagesLinks.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        print("cellForRow: ", indexPath.row + 1)
        let cell : PhotoTableViewCell = tableView.dequeueReusableCellWithIdentifier("firstCell", forIndexPath: indexPath) as! PhotoTableViewCell
        
        if (PhotoTableViewController.downloadedImages[indexPath] == nil) {
            PhotoTableViewController.downloadedImages[indexPath] = cell.imageRecord
            cell.startUpdatingCell(self.imagesLinks[indexPath.row])
        } else {
            cell.imageRecord = PhotoTableViewController.downloadedImages[indexPath]
            cell.photoImageView.image = cell.imageRecord.imageSmall
            cell.stopDownloadingIndicator()
        }
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if ( segue.identifier == ShowInFullScreenSegue) {
            let cell = sender as! PhotoTableViewCell
            let destinationVC = segue.destinationViewController as! ImageInFullSizeViewController
            let imageView : UIImageView? = sender?.imageView
            if (imageView != nil) {
                destinationVC.imageRecord = cell.imageRecord
            }
        }
    }
}