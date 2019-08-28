//
//  CoreDataManager.swift
//  The Suggestion-ATOR MAX
//
//  Created by Estelle Paus on 8/3/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import Foundation
import CoreData
import os.log

class CoreDataManager {
    
    private let modelName: String
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
        }()
    
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    private lazy var storeContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: self.modelName)
        self.seedCoreDataContainerIfFirstLaunch()
        container.loadPersistentStores {
            (storeDescription, error) in
            if let error = error as NSError? {
                os_log("Unresolved loadPersistentStores error:", error.userInfo)
            }
        }
        return container
    }()
    
    func saveContext () {
        guard managedContext.hasChanges else { return }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            os_log("Unresolved error managedContextSave error: ", error.userInfo)
        }
    }
}
// MARK: Private
private extension CoreDataManager {
    
    func seedCoreDataContainerIfFirstLaunch() {
        
        // 1
        let previouslyLaunched = UserDefaults.standard.bool(forKey: "previouslyLaunched")
        if !previouslyLaunched {
            UserDefaults.standard.set(true, forKey: "previouslyLaunched")
            
            // Default directory where the CoreDataStack will store its files
            let directory = NSPersistentContainer.defaultDirectoryURL()
            let url = directory.appendingPathComponent(modelName + ".sqlite")
            
            // 2: Copying the SQLite file
            let seededDatabaseURL = Bundle.main.url(forResource: modelName, withExtension: "sqlite")!
            _ = try? FileManager.default.removeItem(at: url)
            do {
                try FileManager.default.copyItem(at: seededDatabaseURL, to: url)
            } catch let nserror as NSError {
                os_log("seededDatabaseURL copy .sqlite failed, app will survive with error:",nserror.localizedDescription)
            }
            
            // 3: Copying the SHM file
            let seededSHMURL = Bundle.main.url(forResource: modelName, withExtension: "sqlite-shm")!
            let shmURL = directory.appendingPathComponent(modelName + ".sqlite-shm")
            _ = try? FileManager.default.removeItem(at: shmURL)
            do {
                try FileManager.default.copyItem(at: seededSHMURL, to: shmURL)
            } catch let nserror as NSError {
                os_log("seededDatabaseURL copy .sqlite-shm failed, app will survive with error:",nserror.localizedDescription)
            }
            
            // 4: Copying the WAL file
            let seededWALURL = Bundle.main.url(forResource: modelName, withExtension: "sqlite-wal")!
            let walURL = directory.appendingPathComponent(modelName + ".sqlite-wal")
            _ = try? FileManager.default.removeItem(at: walURL)
            do {
                try FileManager.default.copyItem(at: seededWALURL, to: walURL)
            } catch let nserror as NSError {
                os_log("seededDatabaseURL copy .sqlite-wal failed, app will survive with error:",nserror.localizedDescription)
            }
            
            os_log("Seeded Core Data")
        }
    }
}
