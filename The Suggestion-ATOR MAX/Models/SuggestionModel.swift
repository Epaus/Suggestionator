//
//  SuggestionModel.swift
//  The Suggestion-ATOR MAX
//
//  Created by Estelle Paus on 8/11/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import Foundation
import CoreData
import os.log

class SuggestionModel {
    
    var managedContext: NSManagedObjectContext!
    var currentAskFor: AskFor?
    var suggestions = [NSManagedObject]()
    
    init(managedContext: NSManagedObjectContext) {
        self.managedContext = managedContext
    }
    
    func add(newSuggestion: String, completion:((Error?) -> Void)? = nil) {
        
        let suggestion = Suggestion(context: managedContext)
        suggestion.suggestion = newSuggestion
        
        
        if let askFor = currentAskFor,
            let suggestions = askFor.suggestions?.mutableCopy() as? NSMutableOrderedSet {
            suggestions.add(suggestion)
            askFor.suggestions = suggestions
        }
        do {
            try managedContext.save()
            completion?(nil)
        } catch let error as NSError {
            os_log("Save error: ", error.userInfo)
            completion?(error)
        }
    }
    
    func delete(suggestion: Suggestion, indexPath: IndexPath, completion:((Error?) -> Void)? = nil) {
        
        managedContext.delete(suggestion)
        
        do {
            try managedContext.save()
            completion?(nil)
        } catch let error as NSError {
            os_log("Deleting error: ",error.userInfo)
            completion?(error)
        }
    }
    
}
