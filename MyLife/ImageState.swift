//
//  ImageState.swift
//  MyLife
//
//  Created by Андрей Решетников on 27.04.16.
//  Copyright © 2016 mipt. All rights reserved.
//

import Foundation

enum ImageState {
    case NotDownloaded,
    Downloading,
    Downloaded,
    Rendering,
    Rendered,
    Failed
}