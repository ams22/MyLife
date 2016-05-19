//
//  AboutView.swift
//  MyLife
//
//  Created by Андрей Решетников on 19.05.16.
//  Copyright © 2016 mipt. All rights reserved.
//

import Foundation

class AboutView : UIView {
    
    @IBOutlet weak var myNameAboutLabel: UILabel!
    @IBOutlet weak var myTextAboutLabel: UILabel!
    @IBOutlet weak var myAboutImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.myAboutImage.layer.cornerRadius = 21.0
        self.myAboutImage.layer.masksToBounds = true
        self.myAboutImage.layer.borderWidth = 1.0
        self.myAboutImage.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.cornerRadius = 4.0
    }
}

extension AboutView {
    class func instantiateFromNib<T: UIView>() -> T {
        return NSBundle.mainBundle().loadNibNamed("About", owner: nil, options: nil).first as! T
    }
    
    class func loadFromNib() -> Self {
        return instantiateFromNib()
    }
    
    func configureWithAbout(about: About) {
        self.myAboutImage.image = about.avatar
        self.myNameAboutLabel.text = about.username as String
        self.myTextAboutLabel.text = about.text as String
    }
}