//
//  SuggestionTableViewController.swift
//  The Suggestion-ATOR MAX
//
//  Created by Estelle Paus on 8/10/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import UIKit
import CoreData

class SuggestionTableViewController: UITableViewController {

    var managedContext: NSManagedObjectContext!
    var currentAskFor: AskFor?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Suggestions"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "Cell")
        //setupNavigationBar()
        let addButton : UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addSuggestion(_:)))
        addButton.tintColor = .white
        navigationItem.rightBarButtonItem = addButton
    }
    
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
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentAskFor?.suggestions?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            guard let suggestion = currentAskFor?.suggestions?[indexPath.row] as? Suggestion,
                let suggestionText = suggestion.suggestion as String? else { return cell }
        
            cell.textLabel?.text = suggestionText
            return cell
    }
    
    // datasource
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let suggestionToRemove = currentAskFor?.suggestions?[indexPath.row] as? Suggestion,
            editingStyle == .delete else {
                return
        }
        
        managedContext.delete(suggestionToRemove)
        
        do {
            try managedContext.save()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        } catch let error as NSError {
            print("Saving error: \(error), description: \(error.userInfo)")
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
