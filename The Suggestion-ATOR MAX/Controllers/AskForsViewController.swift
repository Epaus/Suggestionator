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
    var model: AskForModel? = nil
    
    lazy var tableView: UITableView = UIElementsManager.createTableView(cellClass: UITableViewCell.self, reuseID: "Cell")
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let model = self.model else { return }
        navigationItem.title = model.currentCategory?.title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureTableView()
        setupNavigationBar()
        let addButton : UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addAskForButtonTapped(_:)))
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
    
    @objc func addAskForButtonTapped(_ sender: UIBarButtonItem) {
        guard let model = self.model else { return }
        
        let alert = UIAlertController(title: "New AskFor",
                                      message: "Add a new askFor",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
            
            guard let textField = alert.textFields?.first,
                let askForToSave = textField.text else { return }
            
            model.add(newAskFor: askForToSave, completion: { error in
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

extension AskForsController : UITableViewDataSource {
    // MARK: - TableViewDataSource functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = self.model else { return 0 }
        return model.currentCategory?.askFors?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let model = self.model,
         let askForToRemove = model.currentCategory?.askFors?[indexPath.row] as? AskFor,
            editingStyle == .delete else { return }
        
        model.delete(askFor: askForToRemove, indexPath: indexPath, completion: { error in
            if let error = error {
                os_log("error = ",error.localizedDescription)
            }
            self.tableView.reloadData()
        })
    }
}

extension AskForsController: UITableViewDelegate {
    // MARK: - UITableViewDelegate functions
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        guard let model = self.model,
         let askFor = model.currentCategory?.askFors?[indexPath.row] as? AskFor,
            let askForTitle = askFor.askFor as String? else { return cell }
        cell.selectionStyle = .none
        cell.textLabel?.text = askForTitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = self.model else { return }
        let askFor = model.currentCategory?.askFors?[indexPath.row] as? AskFor
        let suggestionModel = SuggestionModel.init(managedContext: model.managedContext)
        suggestionModel.currentAskFor = askFor
        suggestionModel.managedContext = model.managedContext
        let vc = SuggestionController()
        vc.model = suggestionModel
       
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

