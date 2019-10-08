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
            } else {
                categories = [NSManagedObject]()
            }
        } catch let error as NSError {
            os_log("Category Fetch error description:", error.userInfo)
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
    
    func askForsForCategory(category: String) -> [NSManagedObject] {
        var askFors = [NSManagedObject]()
        let fetchRequest: NSFetchRequest<SceneCategory> = SceneCategory.fetchRequest()
        let results: [SceneCategory]?
        if category != "" {
            fetchRequest.predicate = NSPredicate(format: "%K = %@",
                                                 argumentArray: [#keyPath(SceneCategory.title), category])
        }
        do {
            results = try managedContext.fetch(fetchRequest)
            askFors = results?.first?.askFors?.array as! [NSManagedObject]
        } catch {
            os_log(.error, "AskFor fetch failure")
        }
        return askFors
    }
    
    func categoryForString(title: String) -> SceneCategory {
        let fetchRequest: NSFetchRequest<SceneCategory> = SceneCategory.fetchRequest()
        var result = SceneCategory()
        if title != "" {
            fetchRequest.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(SceneCategory.title), title])
        }
        do {
            result = try (managedContext.fetch(fetchRequest).first ?? SceneCategory())
        } catch {
            os_log(.error, "SceneCategory failure")
        }
        return result
    }
    
    func deleteCategory(category: SceneCategory) {
        guard let askFors = category.askFors else { return  }
        
        for askFor in askFors  {
            guard let askFor = askFor as? AskFor,
                let suggestions = (askFor as AskFor).suggestions else {
                    os_log("SceneCategoryModel Deleting error: no suggestions for category: ", category.title ?? "")
                    break
            }
            for suggestion in suggestions {
                guard let suggest = (suggestion as? Suggestion) else {
                    os_log("SceneCategoryModel Deleting error: no suggestions for category: ", category.title ?? "")
                    break }
                managedContext.delete(suggest)
            }
            managedContext.delete(askFor)
        }
        managedContext.delete(category)
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            os_log("SceneCategoryModel Deleting error: ",error.userInfo)
        }
        
    }
    
    
}
