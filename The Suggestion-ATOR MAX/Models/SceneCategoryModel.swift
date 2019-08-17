//
//  SceneCategoryModel.swift
//  The Suggestion-ATOR MAX
//
//  Created by Estelle Paus on 8/10/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import Foundation
import CoreData
import os.log

class SceneCategoryModel {
    
    var managedContext: NSManagedObjectContext!
    var categories = [NSManagedObject]()
    var currentCategory: SceneCategory?
    
    init(managedContext: NSManagedObjectContext) {
        self.managedContext = managedContext
        self.updateCategories()
    }
    
    
    // MARK: - coredata stuff
    func updateCategories() {
        let categoryFetch: NSFetchRequest<SceneCategory> = SceneCategory.fetchRequest()
        
        do {
            let results = try managedContext.fetch(categoryFetch)
            if results.count > 0 {
                categories = results
            }
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
    func add(newCategory: String, completion:((Error?) -> Void)? = nil) {
        let category = SceneCategory(context: managedContext)
        category.title = newCategory
        do {
            try managedContext.save()
            completion?(nil)
        } catch let error as NSError {
            os_log("Save error: ", error.userInfo)
            completion?(error)
        }

    }
    
   
    
    
}
