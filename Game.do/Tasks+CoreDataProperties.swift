//
//  Tasks+CoreDataProperties.swift
//  Game.do
//
//  Created by user186880 on 5/27/21.
//
//

import Foundation
import CoreData


extension Tasks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tasks> {
        return NSFetchRequest<Tasks>(entityName: "Tasks")
    }

    @NSManaged public var date: Date
    @NSManaged public var detail: String
    @NSManaged public var shouldRemind: Bool
    @NSManaged public var checked: Bool
    @NSManaged public var savedGame: SavedGame?
}

extension Tasks : Identifiable {

}
