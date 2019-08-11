//
//  SceneCategory+CoreDataProperties.swift
//  The Suggestion-ATOR MAX
//
//  Created by Estelle Paus on 8/10/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//
//

import Foundation
import CoreData


extension SceneCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SceneCategory> {
        return NSFetchRequest<SceneCategory>(entityName: "SceneCategory")
    }

    @NSManaged public var title: String?
    @NSManaged public var askFors: NSOrderedSet?

}

// MARK: Generated accessors for askFors
extension SceneCategory {

    @objc(insertObject:inAskForsAtIndex:)
    @NSManaged public func insertIntoAskFors(_ value: AskFor, at idx: Int)

    @objc(removeObjectFromAskForsAtIndex:)
    @NSManaged public func removeFromAskFors(at idx: Int)

    @objc(insertAskFors:atIndexes:)
    @NSManaged public func insertIntoAskFors(_ values: [AskFor], at indexes: NSIndexSet)

    @objc(removeAskForsAtIndexes:)
    @NSManaged public func removeFromAskFors(at indexes: NSIndexSet)

    @objc(replaceObjectInAskForsAtIndex:withObject:)
    @NSManaged public func replaceAskFors(at idx: Int, with value: AskFor)

    @objc(replaceAskForsAtIndexes:withAskFors:)
    @NSManaged public func replaceAskFors(at indexes: NSIndexSet, with values: [AskFor])

    @objc(addAskForsObject:)
    @NSManaged public func addToAskFors(_ value: AskFor)

    @objc(removeAskForsObject:)
    @NSManaged public func removeFromAskFors(_ value: AskFor)

    @objc(addAskFors:)
    @NSManaged public func addToAskFors(_ values: NSOrderedSet)

    @objc(removeAskFors:)
    @NSManaged public func removeFromAskFors(_ values: NSOrderedSet)

}
