//
//  CoreDataManager.swift
//  The Suggestion-ATOR MAX
//
//  Created by Estelle Paus on 8/3/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//  adapted from Core Data by Tutorials
/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

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
