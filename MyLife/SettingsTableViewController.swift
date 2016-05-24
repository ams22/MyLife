//
//  SettingsTableViewController.swift
//  MyLife
//
//  Created by Андрей Решетников on 26.04.16.
//  Copyright © 2016 mipt. All rights reserved.
//

import Foundation
import UIKit
import VK_ios_sdk

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //-----------------------COLORS------------------------------------------
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        self.navigationController?.navigationBar.barTintColor = uicolorFromHex(0x670067)
        self.view.backgroundColor = uicolorFromHex(0xffff00)
        //-----------------------------------------------------------------------
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 1) {
            switch (indexPath.item) {
                case 0:
                    let alert = UIAlertController(title: "Вы точно хотите выйти из своего профиля?", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                    let actionOk = UIAlertAction(title: "Да", style: UIAlertActionStyle.Default, handler: { action in
                        VKSdk.forceLogout()
                        let secondStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                        let next = secondStoryBoard.instantiateViewControllerWithIdentifier("startNavigationController") as! StartNavigationController
                        self.navigationController?.presentViewController(next, animated: true, completion: nil)
                    })
                    alert.addAction(actionOk)
                    let actionCancel = UIAlertAction(title: "Отмена", style: UIAlertActionStyle.Cancel, handler: nil)
                    alert.addAction(actionCancel)
                    self.presentViewController(alert, animated: true, completion: nil)
                    break
                default:
                    break
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.contentView.backgroundColor = uicolorFromHex(0x670067)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}