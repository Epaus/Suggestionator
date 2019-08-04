//
//  SceneCategory+CoreDataProperties.swift
//  The Suggestion-ATOR MAX
//
//  Created by Estelle Paus on 8/3/19.
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
    @NSManaged public var hasAskFors: NSSet?

}

// MARK: Generated accessors for hasAskFors
extension SceneCategory {

    @objc(addHasAskForsObject:)
    @NSManaged public func addToHasAskFors(_ value: AskFor)

    @objc(removeHasAskForsObject:)
    @NSManaged public func removeFromHasAskFors(_ value: AskFor)

    @objc(addHasAskFors:)
    @NSManaged public func addToHasAskFors(_ values: NSSet)

    @objc(removeHasAskFors:)
    @NSManaged public func removeFromHasAskFors(_ values: NSSet)

}
