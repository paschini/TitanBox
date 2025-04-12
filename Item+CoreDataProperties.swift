//
//  Item+CoreDataProperties.swift
//  TitanBox
//
//  Created by Paschini, Camila on 2022-12-15.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var timestamp: Date?

}

extension Item : Identifiable {

}
