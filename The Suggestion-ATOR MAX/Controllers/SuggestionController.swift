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
    var model: SuggestionModel? = nil
   
    lazy var tableView: UITableView = UIElementsManager.createTableView(cellClass: UITableViewCell.self, reuseID: "Cell")
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let model = self.model else { return }
        navigationItem.title = model.currentAskFor?.askFor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureAddButton()
        configureTableView()
        setupNavigationBar()
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
    
    func configureAddButton() {
        let addButton : UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addSuggestionButtonTapped(_:)))
        addButton.tintColor = .pink
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addSuggestionButtonTapped(_ sender: UIBarButtonItem) {
        guard let model = self.model else { return }
        
        let alert = UIAlertController(title: "New Suggestion",
                                      message: "Add a new suggestion",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
            
            guard let textField = alert.textFields?.first,
                let suggestionToSave = textField.text else { return }
            
            model.add(newSuggestion: suggestionToSave, completion: { error in
                if let error = error {
                    os_log("error = ",error.localizedDescription)
                }
                self.tableView.reloadData()
            })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
   
}

extension SuggestionController: UITableViewDataSource {
    // MARK: UITableViewDataSource functions
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = self.model else { return 0 }
        return model.currentAskFor?.suggestions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let model = self.model,
         let suggestionToRemove = model.currentAskFor?.suggestions?[indexPath.row] as? Suggestion,
            editingStyle == .delete else {
                return
        }
        
        model.delete(suggestion: suggestionToRemove, indexPath: indexPath, completion: { error in
            if let error = error {
                os_log("error = ",error.localizedDescription)
            }
            self.tableView.reloadData()
        })
    }
}
extension SuggestionController: UITableViewDelegate {
    // MARK: - UITableViewDelegate functions
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        guard let model = self.model,
         let suggestion = model.currentAskFor?.suggestions?[indexPath.row] as? Suggestion,
            let suggestionText = suggestion.suggestion as String? else { return cell }
        
        cell.textLabel?.text = suggestionText
        return cell
    }
}
