//
//  TrackCell.swift
//  MyLife
//
//  Created by Андрей Решетников on 22.05.16.
//  Copyright © 2016 mipt. All rights reserved.
//

import Foundation
import UIKit

protocol TrackCellDelegate {
    func downloadTapped(cell: TrackCell)
}

class TrackCell: UITableViewCell {
    
    var delegate: TrackCellDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    
    @IBAction func downloadTapped(sender: AnyObject) {
        delegate?.downloadTapped(self)
    }
}
