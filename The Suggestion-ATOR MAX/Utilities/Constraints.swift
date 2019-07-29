//
//  Constraints.swift
//  The Suggestion-ATOR MAX
//
//  Created by Estelle Paus on 7/28/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import UIKit

class Constraints {
    func constraintWithTopBottomAndCenterXAnchor(field: AnyObject, width: CGFloat, topAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, topConstant: CGFloat, bottomAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, bottomAnchorConstant: CGFloat, centerXAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>, centerXConstant: CGFloat ){
        field.widthAnchor.constraint(equalToConstant: width).isActive = true
        field.topAnchor.constraint(equalTo: topAnchor, constant: topConstant).isActive = true
        field.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomAnchorConstant).isActive = true
        field.centerXAnchor.constraint(equalTo: centerXAnchor, constant: centerXConstant).isActive = true
    }
}
