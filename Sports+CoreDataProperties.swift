//
//  Sports+CoreDataProperties.swift
//  Sports and Players
//
//  Created by admin on 26/12/2021.
//
//

import Foundation
import CoreData


extension Sports {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sports> {
        return NSFetchRequest<Sports>(entityName: "Sports")
    }

    @NSManaged public var image: Data?
    @NSManaged public var name: String?
    @NSManaged public var players: NSSet?

}

// MARK: Generated accessors for players
extension Sports {

    @objc(addPlayersObject:)
    @NSManaged public func addToPlayers(_ value: Players)

    @objc(removePlayersObject:)
    @NSManaged public func removeFromPlayers(_ value: Players)

    @objc(addPlayers:)
    @NSManaged public func addToPlayers(_ values: NSSet)

    @objc(removePlayers:)
    @NSManaged public func removeFromPlayers(_ values: NSSet)

}

extension Sports : Identifiable {

}
