//
//  Box+CoreDataProperties.swift
//  TitanBox
//
//  Created by Paschini, Camila on 2022-12-15.
//
//

import Foundation
import CoreData


extension Box {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Box> {
        return NSFetchRequest<Box>(entityName: "Box")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var timestamp: Date?

}

extension Box : Identifiable {

}
