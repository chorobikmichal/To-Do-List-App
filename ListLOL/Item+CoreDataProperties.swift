//
//  Item+CoreDataProperties.swift
//  ListLOL
//
//  Created by Michal Chorobik on 2017-07-23.
//  Copyright © 2017 Michal Chorobik. All rights reserved.
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item");
    }

    @NSManaged public var position: NSNumber?
    @NSManaged public var details: String?
    @NSManaged public var title: String?
    @NSManaged public var image1: NSObject?
    @NSManaged public var created: NSDate?
    @NSManaged public var image2: NSObject?
    @NSManaged public var toItemType: ItemType?

}
