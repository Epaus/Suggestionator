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
    
    init(managedContext: NSManagedObjectContext) {
        self.managedContext = managedContext

    }
    
    // MARK: - CoreData functions
    
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
}
