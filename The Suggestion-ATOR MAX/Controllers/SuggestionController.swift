//
//  SuggestionTableViewController.swift
//  The Suggestion-ATOR MAX
//
//  Created by Estelle Paus on 8/10/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import UIKit
import CoreData
import os.log

class SuggestionController: UIViewController {

    var managedContext: NSManagedObjectContext!
    var currentAskFor: AskFor?
    lazy var tableView: UITableView = UIElementsManager.createTableView(cellClass: UITableViewCell.self, reuseID: "Cell")
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = currentAskFor?.askFor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureTableView()
        setupNavigationBar()
        let addButton : UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addSuggestion(_:)))
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
    @objc func addSuggestion(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New Suggestion",
                                      message: "Add a new suggestion",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
            
            guard let textField = alert.textFields?.first,
                let suggestionToSave = textField.text else { return }
            
            self.add(newSuggestion: suggestionToSave)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func add(newSuggestion: String) {
        
        let suggestion = Suggestion(context: managedContext)
        suggestion.suggestion = newSuggestion
        
        
        if let askFor = currentAskFor,
            let suggestions = askFor.suggestions?.mutableCopy() as? NSMutableOrderedSet {
            suggestions.add(suggestion)
            askFor.suggestions = suggestions
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Save error: \(error), description: \(error.userInfo)")
        }
        
        tableView.reloadData()
    }
    
    func delete(suggestion: Suggestion, indexPath: IndexPath) {
        
        managedContext.delete(suggestion)
        
        do {
            try managedContext.save()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        } catch let error as NSError {
            os_log("Saving error: ",error.userInfo)
        }
    }
}

extension SuggestionController: UITableViewDataSource {
    // MARK: UITableViewDataSource functions
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentAskFor?.suggestions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let suggestionToRemove = currentAskFor?.suggestions?[indexPath.row] as? Suggestion,
            editingStyle == .delete else {
                return
        }
        
        delete(suggestion: suggestionToRemove, indexPath: indexPath)
    }
}
extension SuggestionController: UITableViewDelegate {
    // MARK: - UITableViewDelegate functions
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        guard let suggestion = currentAskFor?.suggestions?[indexPath.row] as? Suggestion,
            let suggestionText = suggestion.suggestion as String? else { return cell }
        
        cell.textLabel?.text = suggestionText
        return cell
    }
}
