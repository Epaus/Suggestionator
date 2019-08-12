//
//  AskFor+CoreDataProperties.swift
//  The Suggestion-ATOR MAX
//
//  Created by Estelle Paus on 8/10/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//
//

import Foundation
import CoreData


extension AskFor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AskFor> {
        return NSFetchRequest<AskFor>(entityName: "AskFor")
    }

    @NSManaged public var askFor: String?
    @NSManaged public var suggestions: NSOrderedSet?
    @NSManaged public var category: SceneCategory?

}

// MARK: Generated accessors for suggestions
extension AskFor {

    @objc(insertObject:inSuggestionsAtIndex:)
    @NSManaged public func insertIntoSuggestions(_ value: Suggestion, at idx: Int)

    @objc(removeObjectFromSuggestionsAtIndex:)
    @NSManaged public func removeFromSuggestions(at idx: Int)

    @objc(insertSuggestions:atIndexes:)
    @NSManaged public func insertIntoSuggestions(_ values: [Suggestion], at indexes: NSIndexSet)

    @objc(removeSuggestionsAtIndexes:)
    @NSManaged public func removeFromSuggestions(at indexes: NSIndexSet)

    @objc(replaceObjectInSuggestionsAtIndex:withObject:)
    @NSManaged public func replaceSuggestions(at idx: Int, with value: Suggestion)

    @objc(replaceSuggestionsAtIndexes:withSuggestions:)
    @NSManaged public func replaceSuggestions(at indexes: NSIndexSet, with values: [Suggestion])

    @objc(addSuggestionsObject:)
    @NSManaged public func addToSuggestions(_ value: Suggestion)

    @objc(removeSuggestionsObject:)
    @NSManaged public func removeFromSuggestions(_ value: Suggestion)

    @objc(addSuggestions:)
    @NSManaged public func addToSuggestions(_ values: NSOrderedSet)

    @objc(removeSuggestions:)
    @NSManaged public func removeFromSuggestions(_ values: NSOrderedSet)

}
