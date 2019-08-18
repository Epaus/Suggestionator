//
//  RandomizerViewController.swift
//  The Suggestion-ATOR MAX
//
//  Created by Estelle Paus on 7/28/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import UIKit
import CoreData
/*
https://stackoverflow.com/questions/28938660/how-to-lock-orientation-of-one-view-controller-to-portrait-mode-only-in-swift
Describes creating a TabViewController which allows you to specify which orientations you want to allow a viewController
Want to look into this eventually - so saving link here.
*/
class RandomizerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   
    var model: RandomizerViewModel? = nil
   
    
    private lazy var topPickerStackView: UIStackView = UIElementsManager.createUIStackView(width: UIElementSizes.windowWidth, height: UIElementSizes.windowHeight * 0.25, axis: .horizontal, distribution: .equalSpacing, alignment: .center, spacing: 0, backgroundColor: .backgroundPink)
    private var categoryPicker =  UIElementsManager.createUIPickerView(borderWidth: 0, borderColor: .magenta, tintColor: .cyan, textColor: .black)
    private var askForPicker = UIElementsManager.createUIPickerView(borderWidth: 0, borderColor: .magenta, tintColor: .cyan, textColor: .black)
    
    private lazy var bottomPickerStackView: UIStackView = UIElementsManager.createUIStackView(width: UIElementSizes.windowWidth, height: UIElementSizes.windowHeight * 0.25, axis: .horizontal, distribution: .equalSpacing, alignment: .center, spacing: 0, backgroundColor: .backgroundPink)
    private lazy var suggestionPicker = UIElementsManager.createUIPickerView(borderWidth: 0, borderColor: .magenta, tintColor: .cyan, textColor: .black)
    
    private lazy var pinkBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundPink
        view.layer.cornerRadius = 0
        return view
    }()
    private lazy var blueBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundBlue
        view.layer.cornerRadius = 0
        return view
    }()
    
    
    let askForLabel = UIElementsManager.createLabel(text: "Spin for a random AskFor", font: .boldSystemFont(ofSize: 22), textColor: .pink, textAlignment: .center, adjustsFontSizeToFitWidth: true, numberOfLines: 0)
    let suggestionLabel = UIElementsManager.createLabel(text: "Spin for a random Suggestion", font: .boldSystemFont(ofSize: 22), textColor: .backgroundBlue, textAlignment: .center, adjustsFontSizeToFitWidth: true, numberOfLines: 0)
    
    private lazy var labelView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        self.view.backgroundColor = .white
       
        self.view.addSubview(topPickerStackView)
        self.view.addSubview(labelView)
        configureLabelView()
        topPickerStackView.addArrangedSubview(categoryPicker)
        topPickerStackView.addArrangedSubview(askForPicker)
        pinBackground(pinkBackgroundView, to: topPickerStackView)
        
        self.view.addSubview(bottomPickerStackView)
        bottomPickerStackView.addArrangedSubview(suggestionPicker)
        pinBackground(blueBackgroundView, to: bottomPickerStackView)
        
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        askForPicker.dataSource = self
        askForPicker.delegate = self
        suggestionPicker.dataSource = self
        suggestionPicker.delegate = self
      
        NSLayoutConstraint.activate([
            categoryPicker.widthAnchor.constraint(equalToConstant: UIElementSizes.windowWidth * 0.4),
            askForPicker.widthAnchor.constraint(equalToConstant: UIElementSizes.windowWidth * 0.6),
            topPickerStackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            topPickerStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            topPickerStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            labelView.topAnchor.constraint(equalTo: topPickerStackView.bottomAnchor),
            labelView.heightAnchor.constraint(equalToConstant: UIElementSizes.windowHeight * 0.25),
            labelView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            labelView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            bottomPickerStackView.topAnchor.constraint(equalTo: labelView.bottomAnchor),
            bottomPickerStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bottomPickerStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            bottomPickerStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        categoryPicker.reloadAllComponents()
        askForPicker.reloadAllComponents()
        suggestionPicker.reloadAllComponents()
        // Do any additional setup after loading the view.
    }
    
    private func configureLabelView() {
       
        labelView.addSubview(askForLabel)
        labelView.addSubview(suggestionLabel)
        NSLayoutConstraint.activate([
            askForLabel.centerXAnchor.constraint(equalTo: labelView.centerXAnchor),
            askForLabel.centerYAnchor.constraint(equalTo: labelView.centerYAnchor, constant: -20),
            suggestionLabel.centerXAnchor.constraint(equalTo: labelView.centerXAnchor),
            suggestionLabel.centerYAnchor.constraint(equalTo: labelView.centerYAnchor, constant: 20),
            ])
    }
    
    private func pinBackground(_ view: UIView, to stackView: UIStackView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        stackView.insertSubview(view, at: 0)
        view.pin(to: stackView)
    }
    
    
    
    func initializeModels() {
        guard let rModel = self.model,
            let categoryModel = rModel.categoryModel,
            let askForModel = rModel.askForModel,
            let suggestionModel = rModel.suggestionModel else { return }
        categoryModel.currentCategory = categoryModel.categories[0] as? SceneCategory
        askForModel.currentCategory = categoryModel.categories[0] as? SceneCategory
        askForModel.currentAskFor = askForModel.askFors[0] as? AskFor
        askForModel.updateAskFors()
        askForModel.updateSuggestions()
        suggestionModel.currentAskFor = askForModel.currentAskFor
        
        
    }
    
    // Mark: - PickerView delegate and datasource functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerView {
        case categoryPicker:
            guard let model = self.model?.categoryModel else { return 0 }
            return model.categories.count
        case askForPicker:
            guard let model = self.model?.categoryModel else { return 0 }
            return model.currentCategory?.askFors?.count ?? 0
        default:
            guard let model = self.model?.suggestionModel else { return 0 }
            return model.currentAskFor?.suggestions?.count ?? 0
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
        case suggestionPicker:
            guard let model = self.model?.askForModel,
            let askFor = model.currentAskFor,
                let suggestion = askFor.suggestions?[row] as? Suggestion else { return "" }
            title = suggestion.suggestion
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
            let categoryModel = rModel.categoryModel,
            let askForModel = rModel.askForModel,
            let suggestionModel = rModel.suggestionModel else { return }
            let currentCategory = categoryModel.categories[row] as? SceneCategory
            categoryModel.currentCategory = currentCategory
            askForModel.currentCategory = currentCategory
            askForModel.currentAskFor = askForModel.currentCategory?.askFors?[0] as? AskFor
            askForPicker.selectRow(0, inComponent: 0, animated: true)
            askForPicker.reloadAllComponents()
            suggestionModel.currentAskFor  = askForModel.currentAskFor
            askForLabel.text = "Spin for a random AskFor"
            suggestionLabel.text = "Spin for a random Suggestion"
            suggestionPicker.selectRow(0, inComponent: 0, animated: true)
            suggestionPicker.reloadAllComponents()
            
            
            
        case askForPicker:
            guard let rModel = self.model,
                let categoryModel = rModel.categoryModel,
                let askForModel = rModel.askForModel,
                let suggestionModel = rModel.suggestionModel else { return }
            let currentCategory = categoryModel.currentCategory
            askForModel.currentCategory = currentCategory
            askForModel.currentAskFor = currentCategory?.askFors?[row] as? AskFor
            suggestionModel.currentAskFor  = askForModel.currentAskFor
            askForLabel.text = askForModel.currentAskFor?.askFor
            askForModel.updateSuggestions()
            suggestionLabel.text = "Spin for a random Suggestion"
            suggestionPicker.selectRow(0, inComponent: 0, animated: true)
            suggestionPicker.reloadAllComponents()
            
        default:
            guard let rModel = self.model,
                let categoryModel = rModel.categoryModel,
                let askForModel = rModel.askForModel else { return }
            let suggestion = askForModel.currentAskFor?.suggestions?[row] as? Suggestion
            suggestionLabel.text = suggestion?.suggestion
        }
    }

}
extension RandomizerViewController {
    func shouldAutorotate() -> Bool {
        // Lock autorotate
        return false
    }
    
    func supportedInterfaceOrientations() -> Int {
        
        // Only allow Portrait
        return Int(UIInterfaceOrientationMask.portrait.rawValue)
    }
    
    func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        
        // Only allow Portrait
        return UIInterfaceOrientation.portrait
    }
}
