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
        if let statusbarView = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusbarView.backgroundColor = .backgroundPink
        
        }
        if let navController = self.navigationController {
            navController.navigationBar.barStyle = .default
            navController.navigationBar.tintColor = .pink
            navController.navigationBar.barTintColor = .backgroundPink
            navController.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.pink
            ]
        }
    }
}
