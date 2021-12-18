//
//  SavedGame+CoreDataProperties.swift
//  Game.do
//
//  Created by user186880 on 5/23/21.
//
//

import Foundation
import CoreData


extension SavedGame {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedGame> {
        return NSFetchRequest<SavedGame>(entityName: "SavedGame")
    }

    @NSManaged public var id: Int64
    @NSManaged public var image: Data?
    @NSManaged public var title: String?
    @NSManaged public var summary: String?
    @NSManaged public var tasks: NSSet?

}

// MARK: Generated accessors for tasks
extension SavedGame {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: Tasks)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: Tasks)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

}

extension SavedGame : Identifiable {

}
