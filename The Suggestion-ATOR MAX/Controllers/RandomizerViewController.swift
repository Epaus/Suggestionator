//
//  RandomizerViewController.swift
//  The Suggestion-ATOR MAX
//
//  Created by Estelle Paus on 7/28/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import UIKit
import CoreData

class RandomizerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   
    var model: RandomizerViewModel? = nil
   
    
    lazy var pickerStackView: UIStackView = UIElementsManager.createUIStackView(width: UIElementSizes.windowWidth, height: UIElementSizes.windowHeight * 0.3, axis: .horizontal, distribution: .equalSpacing, alignment: .bottom, spacing: 0)
    var categoryPicker =  UIElementsManager.createUIPickerView(borderWidth: 0, borderColor: .magenta, tintColor: .cyan, textColor: .black)
    var askForPicker = UIElementsManager.createUIPickerView(borderWidth: 0, borderColor: .magenta, tintColor: .cyan, textColor: .black)
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(pickerStackView)
        pickerStackView.addArrangedSubview(categoryPicker)
        pickerStackView.addArrangedSubview(askForPicker)
        
        
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        askForPicker.dataSource = self
        askForPicker.delegate = self
      
        
        NSLayoutConstraint.activate([
            categoryPicker.widthAnchor.constraint(equalToConstant: UIElementSizes.windowWidth * 0.4),
            askForPicker.widthAnchor.constraint(equalToConstant: UIElementSizes.windowWidth * 0.6),
            pickerStackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            pickerStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            pickerStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
        
       
        
        categoryPicker.reloadAllComponents()
        askForPicker.reloadAllComponents()
        // Do any additional setup after loading the view.
    }
    
    func initializeModels() {
        guard let rModel = self.model,
            let categoryModel = rModel.categoryModel,
            let askForModel = rModel.askForModel else { return }
        categoryModel.currentCategory = categoryModel.categories[0] as? SceneCategory
        askForModel.currentCategory = categoryModel.categories[0] as? SceneCategory
        askForModel.updateAskFors()
    }
    
    // Mark: - PickerView delegate and datasource functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        guard let model = self.model?.categoryModel else { return 0 }
//        return model.categories.count
        switch pickerView {
        case categoryPicker:
            guard let model = self.model?.categoryModel else { return 0 }
            return model.categories.count
        default:
            guard let model = self.model?.categoryModel else { return 0 }
            return model.currentCategory?.askFors?.count ?? 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var title: String?
        switch pickerView {
        case categoryPicker:
            guard let model = self.model?.categoryModel,
                let category = model.categories[row] as? SceneCategory else { return "" }
            title = category.title
            print(title)
        case askForPicker:
            guard let model = self.model?.categoryModel,
                let askFor = model.currentCategory?.askFors?[row] as? AskFor else { return "" }
            title = askFor.askFor
            print(title)
        default:
            print("how did I get here?")
        }
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case categoryPicker:
            guard let rModel = self.model,
             let categoryModel = rModel.categoryModel else { return }
            let currentCategory = categoryModel.categories[row] as? SceneCategory
            categoryModel.currentCategory = currentCategory
            askForPicker.selectRow(0, inComponent: 0, animated: true)
            askForPicker.reloadAllComponents()
            
            
        default:
            guard let askForModel = self.model?.askForModel else { return }
            //askForModel.currentCategory = self.currentCategory
            let currentAskFor = askForModel.askFors[row] as? AskFor
        }
        pickerView.reloadAllComponents()
       
       
       
    }

}
