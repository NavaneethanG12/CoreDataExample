//
//  CoreExample+CoreDataProperties.swift
//  CoreDataExample
//
//  Created by navaneeth-pt4855 on 08/03/22.
//
//

import Foundation
import CoreData


extension CoreExample {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreExample> {
        return NSFetchRequest<CoreExample>(entityName: "CoreExample")
    }

    @NSManaged public var name: String?
    @NSManaged public var rollNumber: Int16
    @NSManaged public var createdAt: Date?

}

extension CoreExample : Identifiable {

}
