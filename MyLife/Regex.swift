//
//  Regex.swift
//  MyLife
//
//  Created by Андрей Решетников on 10.05.16.
//  Copyright © 2016 mipt. All rights reserved.
//

import Foundation
import UIKit

class Regex {
    let internalExpression: NSRegularExpression
    let pattern: String
    
    init(_ pattern: String) {
        self.pattern = pattern
        do {
            self.internalExpression = try NSRegularExpression(pattern: pattern, options: .CaseInsensitive)
        } catch let error as NSError {
            print(error.description)
            self.internalExpression = NSRegularExpression()
        }
    }
    
    func test(input: String) -> Bool {
        let matches = self.internalExpression.matchesInString(input, options: [], range:NSMakeRange(0, input.characters.count))
        return matches.count > 0
    }
}