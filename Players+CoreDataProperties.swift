//
//  Players+CoreDataProperties.swift
//  Sports and Players
//
//  Created by admin on 26/12/2021.
//
//

import Foundation
import CoreData


extension Players {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Players> {
        return NSFetchRequest<Players>(entityName: "Players")
    }

    @NSManaged public var playerName: String?
    @NSManaged public var age: String
    @NSManaged public var height: String
    @NSManaged public var sports: Sports?

}

extension Players : Identifiable {

}
