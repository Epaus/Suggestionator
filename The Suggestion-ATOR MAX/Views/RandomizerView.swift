//
//  RandomizerView.swift
//  The Suggestion-ATOR MAX
//
//  Created by Estelle Paus on 7/28/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import UIKit

class RandomizerView : UIView {
    
    var categoryPicker =  UIElementsManager.createUIPickerView(borderWidth: 0, borderColor: .magenta, tintColor: .cyan, textColor: .green)
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        self.backgroundColor = .white
        self.addSubview(categoryPicker)
        setConstraints()
    }
    func setAutoResizingMask() {
        categoryPicker.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setConstraints() {
        setAutoResizingMask()
        NSLayoutConstraint.activate([
            categoryPicker.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            categoryPicker.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            categoryPicker.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            categoryPicker.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant: 60),
            categoryPicker.widthAnchor.constraint(equalToConstant: UIElementSizes.windowWidth)
        ])
    }

}
