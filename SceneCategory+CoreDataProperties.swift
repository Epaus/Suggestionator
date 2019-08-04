//
//  SceneCategory+CoreDataProperties.swift
//  The Suggestion-ATOR MAX
//
//  Created by Estelle Paus on 8/4/19.
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
    @NSManaged public var hasAskFors: NSOrderedSet?

}

// MARK: Generated accessors for hasAskFors
extension SceneCategory {

    @objc(insertObject:inHasAskForsAtIndex:)
    @NSManaged public func insertIntoHasAskFors(_ value: AskFor, at idx: Int)

    @objc(removeObjectFromHasAskForsAtIndex:)
    @NSManaged public func removeFromHasAskFors(at idx: Int)

    @objc(insertHasAskFors:atIndexes:)
    @NSManaged public func insertIntoHasAskFors(_ values: [AskFor], at indexes: NSIndexSet)

    @objc(removeHasAskForsAtIndexes:)
    @NSManaged public func removeFromHasAskFors(at indexes: NSIndexSet)

    @objc(replaceObjectInHasAskForsAtIndex:withObject:)
    @NSManaged public func replaceHasAskFors(at idx: Int, with value: AskFor)

    @objc(replaceHasAskForsAtIndexes:withHasAskFors:)
    @NSManaged public func replaceHasAskFors(at indexes: NSIndexSet, with values: [AskFor])

    @objc(addHasAskForsObject:)
    @NSManaged public func addToHasAskFors(_ value: AskFor)

    @objc(removeHasAskForsObject:)
    @NSManaged public func removeFromHasAskFors(_ value: AskFor)

    @objc(addHasAskFors:)
    @NSManaged public func addToHasAskFors(_ values: NSOrderedSet)

    @objc(removeHasAskFors:)
    @NSManaged public func removeFromHasAskFors(_ values: NSOrderedSet)

}
