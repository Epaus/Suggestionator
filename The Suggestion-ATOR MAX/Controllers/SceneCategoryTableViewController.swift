//
//  SuggestionCategoryTableViewController.swift
//  The Suggestion-ATOR MAX
//
//  Created by Estelle Paus on 7/28/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import UIKit
import CoreData
import os.log

class SceneCategoryTableViewController: UIViewController {
    var categories = [NSManagedObject]()
    var currentCategory: SceneCategory?
    var managedContext: NSManagedObjectContext!
    lazy var tableView: UITableView = UIElementsManager.createTableView(cellClass: UITableViewCell.self, reuseID: "Cell")
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Categories"
    }
    
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        updateCategories()
       
        
        setupNavigationBar()
        configureTableView()
        let addButton : UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addCategory(_:)))
        addButton.tintColor = .white
        navigationItem.rightBarButtonItem = addButton
    }
    
    func configureTableView() {
        self.view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
            ])
    }
    
    // MARK: - coredata stuff
    @objc func addCategory(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New Category",
                                      message: "Add a new category",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
            
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else {
                    return
            }
            
            self.save(title: nameToSave)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func save(title: String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "SceneCategory",
                                       in: managedContext)!
        
        let category = NSManagedObject(entity: entity,
                                       insertInto: managedContext)
        
        // 3
        category.setValue(title, forKeyPath: "title")
        
        // 4
        do {
            try managedContext.save()
            categories.append(category)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
extension SceneCategoryTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categories[indexPath.row] as? SceneCategory
        let cell =
            tableView.dequeueReusableCell(withIdentifier: "Cell",
                                          for: indexPath)
        cell.textLabel?.text = category?.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categories[indexPath.row] as? SceneCategory
        let vc = AskForsTableViewController()
        vc.currentCategory = category
        vc.managedContext = managedContext
        navigationController?.pushViewController(vc, animated: true)
        
    }
}
extension SceneCategoryTableViewController : UITableViewDataSource {
    // MARK: - UITableViewDataSource functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let categoryToRemove = categories[indexPath.row] as? SceneCategory,
            editingStyle == .delete else { return }
        
        managedContext.delete(categoryToRemove)
        do {
            try managedContext.save()
            updateCategories()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            
        } catch let error as NSError {
            os_log("Deleting error:", error.userInfo)
        }
    }
}
