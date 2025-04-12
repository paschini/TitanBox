//
//  Testey+CoreDataProperties.swift
//  TitanBox
//
//  Created by Paschini, Camila on 2022-12-15.
//
//

import Foundation
import CoreData


extension Testey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Testey> {
        return NSFetchRequest<Testey>(entityName: "Testey")
    }


}

extension Testey : Identifiable {

}
