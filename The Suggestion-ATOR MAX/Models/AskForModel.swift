//
//  AskForModel.swift
//  The Suggestion-ATOR MAX
//
//  Created by Estelle Paus on 8/11/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import Foundation
import CoreData
import os.log

class AskForModel {
    
    var managedContext: NSManagedObjectContext!
    var currentCategory: SceneCategory?
    var askFors = [NSManagedObject]()
    var currentAskFor: AskFor?
    var suggestions = [NSManagedObject]()
    
    init(managedContext: NSManagedObjectContext) {
        self.managedContext = managedContext
        self.updateAskFors()
    }
    
    // MARK: - CoreData functions
    
    // not currently used. But could be useful later?
    func askForHasSuggestions(newAskFor: String) -> Bool {
       
            let fetchRequest: NSFetchRequest<AskFor> = AskFor.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "%K = %@",
                                                 argumentArray: [#keyPath(AskFor.askFor), newAskFor])
            let results: [AskFor]?
            do {
                results = try managedContext.fetch(fetchRequest)
            } catch {
                return true
            }
            
        return (results?.first?.suggestions?.count ?? 0) > 0
      
    }
    
   
    
    func suggestionsForAskFor(askFor: String) -> [Suggestion] {
        var suggestions = [Suggestion]()
        let fetchRequest: NSFetchRequest<AskFor> = AskFor.fetchRequest()
        let results: [AskFor]?
        
        if askFor != "" {
            fetchRequest.predicate = NSPredicate(format: "%K = %@",
                                                 argumentArray: [#keyPath(AskFor.askFor), askFor])
        }
        do {
            results = try managedContext.fetch(fetchRequest)
            suggestions = results?.first?.suggestions?.array as! [Suggestion]
        } catch {
            os_log(.error, "AskFor fetch failure")
        }
        return suggestions
    }
    
    func updateAskFors() {
        let askForFetch: NSFetchRequest<AskFor> = AskFor.fetchRequest()
        
        do {
            let results = try managedContext.fetch(askForFetch)
            if results.count > 0 {
                askFors = results
            } else {
                askFors = [NSManagedObject]()
            }
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
    func add(newAskFor: String, completion:((Error?) -> Void)? = nil) {
        
        let askFor = AskFor(context: managedContext)
        askFor.askFor = newAskFor
        
        if let category = currentCategory,
            let askFors = category.askFors?.mutableCopy() as? NSMutableOrderedSet {
            askFors.add(askFor)
            category.askFors = askFors
        }
        
        do {
            try managedContext.save()
            completion?(nil)
        } catch let error as NSError {
            os_log("Save error: ", error.userInfo)
            completion?(error)
        }
    }
    
    func delete(askFor: AskFor, indexPath: IndexPath, completion:((Error?) -> Void)? = nil) {
        
        managedContext.delete(askFor)
        
        do {
            try managedContext.save()
            completion?(nil)
        } catch let error as NSError {
            os_log("Deleting error: ",error.userInfo)
            completion?(error)
        }
    }
    
    func updateSuggestions() {
        let suggestionFetch: NSFetchRequest<Suggestion> = Suggestion.fetchRequest()
        
        do {
            let results = try managedContext.fetch(suggestionFetch)
            if results.count > 0 {
                suggestions = results
            } else {
                suggestions = [NSManagedObject]()
            }
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
    func askForForString(title: String) -> AskFor {
        let fetchRequest: NSFetchRequest<AskFor> = AskFor.fetchRequest()
        var result = AskFor()
        if title != "" {
            fetchRequest.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(AskFor.askFor), title])
        }
        do {
            result = try (managedContext.fetch(fetchRequest).first ?? AskFor())
        } catch {
            os_log(.error, "AskFor failure")
        }
        return result
    }
}
