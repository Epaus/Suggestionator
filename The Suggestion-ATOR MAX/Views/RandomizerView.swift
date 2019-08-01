//
//  RandomizerView.swift
//  The Suggestion-ATOR MAX
//
//  Created by Estelle Paus on 7/28/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import UIKit

class RandomizerView : UIView {
    lazy var pickerStackView: UIStackView = UIElementsManager.createUIStackView(width: UIElementSizes.windowWidth, height: UIElementSizes.windowHeight * 0.3, axis: .horizontal, distribution: .equalSpacing, alignment: .center, spacing: 0)
    var categoryPicker =  UIElementsManager.createUIPickerView(borderWidth: 0, borderColor: .magenta, tintColor: .cyan, textColor: .white)
    lazy var askForPicker = UIElementsManager.createUIPickerView(borderWidth: 0, borderColor: .magenta, tintColor: .cyan, textColor: .white)
//    lazy var askForLabelView = UIView()
//    lazy var suggestionLabelView = UIView()
//    lazy var suggestionPicker = UIElementsManager.createUIPickerView(borderWidth: 0, borderColor: .clear, tintColor: .gray, textColor: .black)
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        NSLayoutConstraint.activate([
            categoryPicker.widthAnchor.constraint(equalToConstant: 100),
            categoryPicker.heightAnchor.constraint(equalToConstant: 100)
            ]
        )
        NSLayoutConstraint.activate([
            askForPicker.widthAnchor.constraint(equalToConstant: 100),
            askForPicker.heightAnchor.constraint(equalToConstant: 100)
            ]
        )
        pickerStackView.addArrangedSubview(categoryPicker)
        pickerStackView.addArrangedSubview(askForPicker)
        addSubview(pickerStackView)
       
//        addSubview(askForLabelView)
//        addSubview(suggestionLabelView)
//        addSubview(suggestionPicker)
        setConstraints()
    }
    func setAutoResizingMask() {
        pickerStackView.translatesAutoresizingMaskIntoConstraints = false
        categoryPicker.translatesAutoresizingMaskIntoConstraints = false
        askForPicker.translatesAutoresizingMaskIntoConstraints = false
//        askForLabelView.translatesAutoresizingMaskIntoConstraints = false
//        suggestionLabelView.translatesAutoresizingMaskIntoConstraints = false
//        suggestionPicker.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setConstraints() {
        setAutoResizingMask()
        NSLayoutConstraint.activate([
            pickerStackView.topAnchor.constraint(equalTo: topAnchor),
            pickerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pickerStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
    }

}
