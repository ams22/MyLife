//
//  MenuController.swift
//  MyLife
//
//  Created by Андрей Решетников on 26.04.16.
//  Copyright © 2016 mipt. All rights reserved.
//

import Foundation
import UIKit

class MenuController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("UserInfoMenuCell", forIndexPath: indexPath) as! UserInfoMenuCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("TimetableMenuCell", forIndexPath: indexPath) as! TimetableMenuCell
            cell.timetableLabel?.text = "Расписание"
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("SettingsMenuCell", forIndexPath: indexPath) as! SettingsMenuCell
            cell.settingsLabel?.text = "Настройки"
            return cell
        case 3:
            let cell = tableView.dequeueReusableCellWithIdentifier("MusicMenuCell", forIndexPath: indexPath) as! MusicMenuCell
            cell.musicLabel?.text = "Музыка"
            return cell
        case 4:
            let cell = tableView.dequeueReusableCellWithIdentifier("PhotoMenuCell", forIndexPath: indexPath) as! PhotoMenuCell
            cell.photoLabel?.text = "Фотографии"
            return cell
        default:
            return tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "menuToMusicTableViewController") {
            let destination = segue.destinationViewController as! UINavigationController
            let controller = destination.childViewControllers.first as! MusicTableViewController
            controller.userID = GlobalStorage.userID
        }
        if (segue.identifier == "menuToImageTableViewController") {
            let destination = segue.destinationViewController as! UINavigationController
            let controller = destination.childViewControllers.first as! PhotoTableViewController
            controller.userID = GlobalStorage.userID
        }
    }
//    UINavigationController *destination = segue.destinationViewController;
//    MGRListViewController *controller = destination.viewControllers.firstObject;
//    controller.session = self.session;
    
    
}