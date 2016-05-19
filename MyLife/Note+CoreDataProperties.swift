//
//  Note+CoreDataProperties.swift
//  MyLife
//
//  Created by Андрей Решетников on 18.05.16.
//  Copyright © 2016 mipt. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Note {

    @NSManaged var plans: String?
    
}
