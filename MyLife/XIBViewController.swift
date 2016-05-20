//
//  XIBViewController.swift
//  MyLife
//
//  Created by Андрей Решетников on 19.05.16.
//  Copyright © 2016 mipt. All rights reserved.
//

import Foundation

class XIBViewController: UIViewController {
    
    @IBOutlet weak var addButton: UIButton!
    var lastPostView: AboutView = AboutView()
    let dataSource: AboutDataSource = AboutDataSource()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func randomPostFrame() -> CGRect {
        let width = max(256, min(150.0 + CGFloat(arc4random()) % (CGFloat)(CGRectGetWidth(self.view.bounds) - 100.0), 350))
        let height = min(250.0 + CGFloat(arc4random()) % min(500.0, (CGFloat)(CGRectGetHeight(self.view.bounds) - 200.0)), 600)
        let x = CGFloat(arc4random()) % (CGFloat)(CGRectGetWidth(self.view.bounds) - width)
        let y = max(CGFloat(arc4random()) % (CGFloat)(CGRectGetHeight(self.view.bounds) - height), (self.navigationController?.navigationBar.frame.height)! + (UIApplication.sharedApplication().statusBarFrame.size.height))
        
        return CGRectMake(x, y, width, height)
    }
    
    @IBAction func add(sender: AnyObject) {
        let aboutView = AboutView.loadFromNib()
        aboutView.configureWithAbout(self.dataSource.randomPost())
        aboutView.frame = self.randomPostFrame()
        self.view.insertSubview(aboutView, belowSubview: self.addButton)
        
        lastPostView.alpha = 0.3
        lastPostView = aboutView
    }
    
}