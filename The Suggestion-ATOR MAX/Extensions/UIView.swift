//
//  UIView.swift
//  The Suggestion-ATOR MAX
//
//  Created by Estelle Paus on 8/17/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import UIKit


public extension UIView {
    
    func pin(to view: UIView) {
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
}
