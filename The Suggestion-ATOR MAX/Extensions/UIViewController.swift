//
//  UIViewController.swift
//  The Suggestion-ATOR MAX
//
//  Created by Estelle Paus on 8/10/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import UIKit

extension UIViewController {
    func setupNavigationBar() {
        
        if let navController = self.navigationController {
            navController.navigationBar.barStyle = .black
            navController.navigationBar.tintColor = .white
            navController.navigationBar.barTintColor = .pink
            navController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white
            ]
        }
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
}
