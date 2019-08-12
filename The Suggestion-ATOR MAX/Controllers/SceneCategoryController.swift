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

class SceneCategoryController: UIViewController {
    var currentCategory: SceneCategory?
    var model: SceneCategoryModel? = nil
    
    lazy var tableView: UITableView = UIElementsManager.createTableView(cellClass: UITableViewCell.self, reuseID: "Cell")
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Categories"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupNavigationBar()
        configureTableView()
        let addButton : UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addCategoryButtonTapped(_:)))
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
    
    @objc func addCategoryButtonTapped(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New Category",
                                      message: "Add a new category",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
            
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else {
                    return
            }
            guard let vm = self.model else { return }
            vm.add(newCategory: nameToSave, completion: { error in
                if let error = error {
                    os_log("error = ",error.localizedDescription)
                }
                vm.updateCategories()
            })
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    

}
extension SceneCategoryController: UITableViewDelegate {
    // MARK: - UITableViewDelegate functions
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = self.model else { return UITableViewCell() }
        let category = model.categories[indexPath.row] as? SceneCategory
        let cell =
            tableView.dequeueReusableCell(withIdentifier: "Cell",
                                          for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = category?.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = self.model else { return  }
        let category = model.categories[indexPath.row] as? SceneCategory
        let askForModel = AskForModel.init(managedContext: model.managedContext)
        askForModel.currentCategory = category
        let vc = AskForsController()
        vc.model = askForModel
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension SceneCategoryController : UITableViewDataSource {
    // MARK: - UITableViewDataSource functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = self.model else { return 0 }
        return model.categories.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let model = self.model,
            let categoryToRemove = model.categories[indexPath.row] as? SceneCategory,
            editingStyle == .delete else { return }
        
        model.managedContext.delete(categoryToRemove)
        do {
            try model.managedContext.save()
            model.updateCategories()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } catch let error as NSError {
            os_log("Deleting error:", error.userInfo)
        }
    }
}
