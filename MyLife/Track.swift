//
//  Track.swift
//  MyLife
//
//  Created by Андрей Решетников on 22.05.16.
//  Copyright © 2016 mipt. All rights reserved.
//

import Foundation

class Track {
    var name: String?
    var artist: String?
    var previewUrl: String?
    
    init(name: String?, artist: String?, previewUrl: String?) {
        self.name = name
        self.artist = artist
        self.previewUrl = previewUrl
    }
}