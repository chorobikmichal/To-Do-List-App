//
//  Item+CoreDataClass.swift
//  ListLOL
//
//  Created by Michal Chorobik on 2017-07-23.
//  Copyright © 2017 Michal Chorobik. All rights reserved.
//

import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject {

    public override func awakeFromInsert() {
        
        super.awakeFromInsert()
        
        self.created = NSDate()
    }
    
}
