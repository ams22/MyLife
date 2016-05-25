//
//  PhotoTableViewController.swift
//  MyLife
//
//  Created by Андрей Решетников on 26.04.16.
//  Copyright © 2016 mipt. All rights reserved.
//

import Foundation
import UIKit
import VK_ios_sdk

class PhotoTableViewController: UITableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var userID = ""
    var imagesLinks: [String] = []
    var imageDownloader: ImageDownloader!
    static var downloadedImages = [NSIndexPath : ImageRecord]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //-----------------------COLORS------------------------------------------
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = uicolorFromHex(0x670067)
        //-----------------------------------------------------------------------
        if self.revealViewController() != nil {
            menuButton.tintColor = UIColor.whiteColor()
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        PhotoTableViewController.downloadedImages.removeAll()
        
        if (userID == "") {
            let alert = UIAlertController(title: "Вы не залогинились через вк", message: "Вот котики", preferredStyle: UIAlertControllerStyle.Alert)
            let actionOk = UIAlertAction(title: "Хорошо", style: UIAlertActionStyle.Default, handler: nil)
            alert.addAction(actionOk)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        let filePath = NSHomeDirectory() + "/Library/Caches/test.txt"
        do {
            self.imagesLinks = (try String(contentsOfFile: filePath, encoding: NSUTF8StringEncoding)).componentsSeparatedByString("\n")
        } catch _ as NSError {
            let path = NSBundle.mainBundle().pathForResource("downloadingList", ofType: "txt")
            self.imagesLinks = (try! String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)).componentsSeparatedByString("\n")
        }
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
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
        
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = uicolorFromHex(0xffff00)
        } else {
            cell.backgroundColor = uicolorFromHex(0x670067)
        }
        
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