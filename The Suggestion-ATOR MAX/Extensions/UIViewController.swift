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
}
