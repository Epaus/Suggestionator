//
//  AsForsTableViewController.swift
//  The Suggestion-ATOR MAX
//
//  Created by Estelle Paus on 8/4/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import UIKit
import CoreData
import os.log

class AskForsController: UIViewController {
    var managedContext: NSManagedObjectContext!
    var currentCategory: SceneCategory?
    lazy var tableView: UITableView = UIElementsManager.createTableView(cellClass: UITableViewCell.self, reuseID: "Cell")
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = currentCategory?.title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureTableView()
        setupNavigationBar()
        let addButton : UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addAskFor(_:)))
        addButton.tintColor = .white
        navigationItem.rightBarButtonItem = addButton
    }
    
    func configureTableView() {
        self.view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "Cell")
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
            ])
    }
    
    // MARK: - CoreData functions
    
    @objc func addAskFor(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New AskFor",
                                      message: "Add a new askFor",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
            
            guard let textField = alert.textFields?.first,
                let askForToSave = textField.text else { return }
            
            self.add(newAskFor: askForToSave)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func add(newAskFor: String) {
        
        let askFor = AskFor(context: managedContext)
        askFor.askFor = newAskFor
        
        if let category = currentCategory,
            let askFors = category.askFors?.mutableCopy() as? NSMutableOrderedSet {
            askFors.add(askFor)
            category.askFors = askFors
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Save error: \(error), description: \(error.userInfo)")
        }
        
        tableView.reloadData()
    }
    
    func delete(askFor: AskFor, indexPath: IndexPath) {
        
        managedContext.delete(askFor)
        
        do {
            try managedContext.save()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        } catch let error as NSError {
            os_log("Saving error: ",error.userInfo)
        }
    }
}

extension AskForsController : UITableViewDataSource {
    // MARK: - TableViewDataSource functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentCategory?.askFors?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let askForToRemove = currentCategory?.askFors?[indexPath.row] as? AskFor,
            editingStyle == .delete else { return }
        
       delete(askFor: askForToRemove, indexPath: indexPath)
    }
}

extension AskForsController: UITableViewDelegate {
    // MARK: - UITableViewDelegate functions
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        guard let askFor = currentCategory?.askFors?[indexPath.row] as? AskFor,
            let askForTitle = askFor.askFor as String? else { return cell }
        
        cell.textLabel?.text = askForTitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let askFor = currentCategory?.askFors?[indexPath.row] as? AskFor
        let vc = SuggestionController()
        vc.currentAskFor = askFor
        vc.managedContext = managedContext
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

