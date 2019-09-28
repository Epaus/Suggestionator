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
    
    let numRows = 1000
    var midPoint = 500
   
    // MARK: - topPickerStackView elements
    private lazy var topPickerStackView: UIStackView = UIElementsManager.createUIStackView( axis: .horizontal, distribution: .equalSpacing, alignment: .bottom, spacing: 0)
    private var categoryPicker =  UIElementsManager.createUIPickerView(borderWidth: 0, borderColor: .magenta, tintColor: .cyan, textColor: .black)
    private var askForPicker = UIElementsManager.createUIPickerView(borderWidth: 0, borderColor: .clear, tintColor: .clear, textColor: .black)
    private lazy var pinkBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundPink
        view.layer.cornerRadius = 0
        return view
    }()
    
    
    // MARK: - bottomPickerStackView elements
    private lazy var bottomPickerStackView: UIStackView = UIElementsManager.createUIStackView(axis: .horizontal, distribution: .equalSpacing, alignment: .center, spacing: 0)
    private lazy var suggestionPicker = UIElementsManager.createUIPickerView(borderWidth: 0, borderColor: .clear, tintColor: .clear, textColor: .black)
    private lazy var blueBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundBlue
        view.layer.cornerRadius = 0
        return view
    }()
    
    // MARK: - labelView elements
    private let askForLabel = UIElementsManager.createLabel(text: "Spin for a random AskFor", font: .boldSystemFont(ofSize: 22), textColor: .pink, textAlignment: .center, adjustsFontSizeToFitWidth: true, numberOfLines: 0)
    private let suggestionLabel = UIElementsManager.createLabel(text: "Spin for a random Suggestion", font: .boldSystemFont(ofSize: 22), textColor: .backgroundBlue, textAlignment: .center, adjustsFontSizeToFitWidth: true, numberOfLines: 0)
    private lazy var labelView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var categoryPickerWidthConstraint = NSLayoutConstraint()
    var askForPickerWidthConstraint = NSLayoutConstraint()
    var categoryPickerCenterYConstraint = NSLayoutConstraint()
    var askForPickerCenterYConstraint = NSLayoutConstraint()
    var topPickerStackViewTopAnchor = NSLayoutConstraint()
    var topPickerStackViewLeadingAnchor = NSLayoutConstraint()
    var topPickerStackViewTrailingAnchor = NSLayoutConstraint()
    var topPickerStackViewHeightAnchor = NSLayoutConstraint()
    var topPickerStackViewWidthAnchor = NSLayoutConstraint()
    var labelViewTopAnchor = NSLayoutConstraint()
    var labelViewHeightAnchor = NSLayoutConstraint()
    var labelViewLeadingAnchor = NSLayoutConstraint()
    var labelViewTrailingAnchor = NSLayoutConstraint()
    var labelViewBottomAnchor = NSLayoutConstraint()
    var suggestionPickerCenterYConstraint = NSLayoutConstraint()
    var bottomPickerStackViewTopAnchor = NSLayoutConstraint()
    var bottomPickerStackViewLeadingAnchor = NSLayoutConstraint()
    var bottomPickerStackViewTrailingAnchor = NSLayoutConstraint()
    var bottomPickerStackViewBottomAnchor = NSLayoutConstraint()
    var bottomPickerStackViewHeightAnchor = NSLayoutConstraint()
    var bottomPickerStackViewWidthAnchor = NSLayoutConstraint()
    var askForLabelCenterYAnchor = NSLayoutConstraint()
    var askForLabelLeadingAnchor = NSLayoutConstraint()
    var askForLabelTrailingAnchor = NSLayoutConstraint()
    var suggestionLabelCenterYAnchor = NSLayoutConstraint()
    var suggestionLabelLeadingAnchor = NSLayoutConstraint()
    var suggestionLabelTrailingAnchor = NSLayoutConstraint()
   
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        guard model != nil else { return }
        updatePickersForModels()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundPink
         if #available(iOS 13.0, *) {
                  
               } else {
                   if let statusbarView = UIApplication.shared.value(forKey: "statusBar") as? UIView {
                       statusbarView.backgroundColor = .backgroundPink
                   }
               }
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        NotificationCenter.default.addObserver(self, selector: #selector(adjustConstraintsForOrientation), name: UIDevice.orientationDidChangeNotification, object: nil)
        self.view.backgroundColor = .white
        configureLabelView()
        configurePickers()
        adjustConstraintsForOrientation()
        checkForEmptyModels()
        guard let vm = model else { return }
        vm.initializeModels(completion: {
            vm.populateArrays()
            self.categoryPicker.reloadAllComponents()
            self.categoryPicker.selectRow(0, inComponent:0, animated:false)
            self.askForPicker.reloadAllComponents()
            self.askForPicker.selectRow(0, inComponent:0, animated:false)
            self.suggestionPicker.reloadAllComponents()
            self.suggestionPicker.selectRow(500, inComponent:0, animated:false)
        })
    }
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Configure views
    private func configureLabelView() {
        labelView.addSubview(askForLabel)
        labelView.addSubview(suggestionLabel)
        self.view.addSubview(labelView)
    }
    
    private func configurePickers() {
        self.view.addSubview(topPickerStackView)
        
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
        
        categoryPicker.reloadAllComponents()
        askForPicker.reloadAllComponents()
        suggestionPicker.reloadAllComponents()
    }
    
    private func pinBackground(_ view: UIView, to stackView: UIStackView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        stackView.insertSubview(view, at: 0)
        view.pin(to: stackView)
    }
    
    private func setPortraitConstraints() {
       
        NSLayoutConstraint.deactivate([
            categoryPickerWidthConstraint,
            categoryPickerCenterYConstraint,
            askForPickerWidthConstraint,
            askForPickerCenterYConstraint,
            topPickerStackViewTopAnchor,
            topPickerStackViewLeadingAnchor,
            topPickerStackViewTrailingAnchor,
            topPickerStackViewHeightAnchor,
            topPickerStackViewWidthAnchor,
            labelViewTopAnchor,
            labelViewHeightAnchor,
            labelViewLeadingAnchor,
            labelViewTrailingAnchor,
            labelViewBottomAnchor,
            suggestionPickerCenterYConstraint,
            bottomPickerStackViewTopAnchor,
            bottomPickerStackViewLeadingAnchor,
            bottomPickerStackViewTrailingAnchor,
            bottomPickerStackViewBottomAnchor,
            bottomPickerStackViewHeightAnchor,
            bottomPickerStackViewWidthAnchor,
            askForLabelCenterYAnchor,
            askForLabelLeadingAnchor,
            askForLabelTrailingAnchor,
            suggestionLabelCenterYAnchor,
            suggestionLabelLeadingAnchor,
            suggestionLabelTrailingAnchor
        ])
        categoryPickerWidthConstraint = categoryPicker.widthAnchor.constraint(lessThanOrEqualTo: self.view.widthAnchor, multiplier: 0.4)
        categoryPickerCenterYConstraint = categoryPicker.centerYAnchor.constraint(equalTo:topPickerStackView.centerYAnchor, constant: 0)
        askForPickerWidthConstraint = askForPicker.widthAnchor.constraint(lessThanOrEqualTo: self.view.widthAnchor, multiplier: 0.6)
        askForPickerCenterYConstraint = askForPicker.centerYAnchor.constraint(equalTo:topPickerStackView.centerYAnchor, constant: 0)
        topPickerStackViewTopAnchor = topPickerStackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0)
        topPickerStackViewLeadingAnchor = topPickerStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        topPickerStackViewTrailingAnchor = topPickerStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        topPickerStackViewHeightAnchor = topPickerStackView.heightAnchor.constraint(greaterThanOrEqualTo: self.view.heightAnchor, multiplier: 0.4)
        topPickerStackViewWidthAnchor = topPickerStackView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        labelViewTopAnchor = labelView.topAnchor.constraint(equalTo: topPickerStackView.bottomAnchor)
        labelViewHeightAnchor = labelView.heightAnchor.constraint(lessThanOrEqualTo: self.view.heightAnchor, multiplier: 0.2)
        labelViewLeadingAnchor = labelView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        labelViewTrailingAnchor = labelView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        suggestionPickerCenterYConstraint = suggestionPicker.centerYAnchor.constraint(equalTo:bottomPickerStackView.centerYAnchor, constant: 0)
        bottomPickerStackViewTopAnchor = bottomPickerStackView.topAnchor.constraint(equalTo: labelView.bottomAnchor)
        bottomPickerStackViewLeadingAnchor = bottomPickerStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        bottomPickerStackViewTrailingAnchor = bottomPickerStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        bottomPickerStackViewBottomAnchor = bottomPickerStackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        bottomPickerStackViewHeightAnchor = bottomPickerStackView.heightAnchor.constraint(lessThanOrEqualTo: self.view.heightAnchor, multiplier: 0.2)
        askForLabelCenterYAnchor = askForLabel.centerYAnchor.constraint(equalTo: labelView.centerYAnchor, constant: -20)
        askForLabelLeadingAnchor = askForLabel.leadingAnchor.constraint(equalTo: labelView.leadingAnchor, constant: 10)
        askForLabelTrailingAnchor = askForLabel.trailingAnchor.constraint(equalTo: labelView.trailingAnchor, constant: -10)
        suggestionLabelCenterYAnchor = suggestionLabel.centerYAnchor.constraint(equalTo: labelView.centerYAnchor, constant: 20)
        suggestionLabelLeadingAnchor = suggestionLabel.leadingAnchor.constraint(equalTo: labelView.leadingAnchor, constant: 10)
        suggestionLabelTrailingAnchor = suggestionLabel.trailingAnchor.constraint(equalTo: labelView.trailingAnchor, constant: -10)
        
        NSLayoutConstraint.activate([
        categoryPickerWidthConstraint,
        categoryPickerCenterYConstraint,
        askForPickerWidthConstraint,
        askForPickerCenterYConstraint,
        topPickerStackViewTopAnchor,
        topPickerStackViewLeadingAnchor,
        topPickerStackViewTrailingAnchor,
        topPickerStackViewWidthAnchor,
        topPickerStackViewHeightAnchor,
        labelViewTopAnchor,
        labelViewHeightAnchor,
        labelViewLeadingAnchor,
        labelViewTrailingAnchor,
        suggestionPickerCenterYConstraint,
        bottomPickerStackViewTopAnchor,
        bottomPickerStackViewLeadingAnchor,
        bottomPickerStackViewTrailingAnchor,
        bottomPickerStackViewBottomAnchor,
        askForLabelTrailingAnchor,
        askForLabelLeadingAnchor,
        askForLabelCenterYAnchor,
        suggestionLabelTrailingAnchor,
        suggestionLabelLeadingAnchor,
        suggestionLabelCenterYAnchor
           
            ])
    }
    
    func setLandscapeConstraints() {
        NSLayoutConstraint.deactivate([
            categoryPickerWidthConstraint,
            categoryPickerCenterYConstraint,
            askForPickerWidthConstraint,
            askForPickerCenterYConstraint,
            topPickerStackViewTopAnchor,
            topPickerStackViewLeadingAnchor,
            topPickerStackViewTrailingAnchor,
            topPickerStackViewHeightAnchor,
            topPickerStackViewWidthAnchor,
            labelViewTopAnchor,
            labelViewHeightAnchor,
            labelViewLeadingAnchor,
            labelViewTrailingAnchor,
            labelViewBottomAnchor,
            bottomPickerStackViewTopAnchor,
            bottomPickerStackViewLeadingAnchor,
            bottomPickerStackViewTrailingAnchor,
            bottomPickerStackViewBottomAnchor,
            bottomPickerStackViewWidthAnchor
            ])
        categoryPickerWidthConstraint = categoryPicker.widthAnchor.constraint(lessThanOrEqualTo: self.topPickerStackView.widthAnchor, multiplier: 0.4)
        askForPickerWidthConstraint = askForPicker.widthAnchor.constraint(lessThanOrEqualTo: self.topPickerStackView.widthAnchor, multiplier: 0.6)
        topPickerStackViewTopAnchor = topPickerStackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0)
        topPickerStackViewLeadingAnchor = topPickerStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0)
        topPickerStackViewTrailingAnchor = topPickerStackView.trailingAnchor.constraint(equalTo: bottomPickerStackView.leadingAnchor, constant: 0)
        topPickerStackViewHeightAnchor = topPickerStackView.heightAnchor.constraint(lessThanOrEqualTo: self.view.heightAnchor, multiplier: 0.5)
        bottomPickerStackViewTopAnchor = bottomPickerStackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0)
        bottomPickerStackViewLeadingAnchor = bottomPickerStackView.leadingAnchor.constraint(equalTo: topPickerStackView.trailingAnchor, constant: 0)
        bottomPickerStackViewTrailingAnchor = bottomPickerStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0)
        bottomPickerStackViewBottomAnchor = bottomPickerStackView.bottomAnchor.constraint(equalTo: labelView.topAnchor)
        bottomPickerStackViewHeightAnchor = topPickerStackView.heightAnchor.constraint(lessThanOrEqualTo: self.view.heightAnchor, multiplier: 0.5)
        bottomPickerStackViewWidthAnchor = bottomPickerStackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.35)
        labelViewTopAnchor = labelView.topAnchor.constraint(equalTo: topPickerStackView.bottomAnchor)
        labelViewLeadingAnchor = labelView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant:0)
        labelViewTrailingAnchor = labelView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0)
        labelViewHeightAnchor = labelView.heightAnchor.constraint(greaterThanOrEqualTo: self.view.heightAnchor, multiplier: 0.4)
        labelViewBottomAnchor = labelView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        askForLabelCenterYAnchor = askForLabel.centerYAnchor.constraint(equalTo: labelView.centerYAnchor, constant: -20)
        askForLabelLeadingAnchor = askForLabel.leadingAnchor.constraint(equalTo: labelView.leadingAnchor, constant: 10)
        askForLabelTrailingAnchor = askForLabel.trailingAnchor.constraint(equalTo: labelView.trailingAnchor, constant: -10)
        suggestionLabelCenterYAnchor = suggestionLabel.centerYAnchor.constraint(equalTo: labelView.centerYAnchor, constant: 20)
        suggestionLabelLeadingAnchor = suggestionLabel.leadingAnchor.constraint(equalTo: labelView.leadingAnchor, constant: 10)
        suggestionLabelTrailingAnchor = suggestionLabel.trailingAnchor.constraint(equalTo: labelView.trailingAnchor, constant: -10)
        
        NSLayoutConstraint.activate([
            categoryPickerWidthConstraint,
                askForPickerWidthConstraint,
                topPickerStackViewTopAnchor,
                topPickerStackViewLeadingAnchor,
                topPickerStackViewTrailingAnchor,
                labelViewTopAnchor,
                labelViewHeightAnchor,
                labelViewLeadingAnchor,
                labelViewTrailingAnchor,
                labelViewBottomAnchor,
                bottomPickerStackViewTopAnchor,
                bottomPickerStackViewLeadingAnchor,
                bottomPickerStackViewTrailingAnchor,
                bottomPickerStackViewBottomAnchor,
                bottomPickerStackViewWidthAnchor,
                askForLabelCenterYAnchor,
                askForLabelLeadingAnchor,
                askForLabelTrailingAnchor,
                suggestionLabelCenterYAnchor,
                suggestionLabelLeadingAnchor,
                suggestionLabelTrailingAnchor
            ])
    }
    
   
    
    // MARK: - PickerView delegate and datasource functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let model = self.model else { return 0 }
        switch pickerView {
        case categoryPicker:
            return model.categoryArray.count
            
        case askForPicker:
            return numRows //model.askForArray.count
            
        default:
            return numRows  //model.suggestionsArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var title: String?
        guard let model = self.model else { return "" }
        switch pickerView {
        case categoryPicker:
            title = model.categoryArray[row]
        case askForPicker:
            let index = getInfiniteIndexForArrayWithALL(array: model.askForArray, row: row)
            title = model.askForArray[index]
        case suggestionPicker:
            let index = row % model.suggestionsArray.count
            if model.suggestionsArray.count > 1 {
                title = model.suggestionsArray[index]
            } else {
                title = ""
            }
           
        default:
            print("how did I get here?")
        }
        print("titleForRow row = ", row)
        return title
    }
    
    func getInfiniteIndexForArrayWithALL(array: [String], row: Int) -> Int {
        if row == 0 {
            return 0
        }
        return  (row % array.count == 0) ? 1 : row % array.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case categoryPicker:
            guard let rModel = self.model else { return }
            let pickerTitle = rModel.categoryArray[row]
            let currentCategory = (row != 0) ? rModel.categoryForTitle(title: pickerTitle) : nil
           
            rModel.updateAskForArray(category: currentCategory?.title ?? "")
            rModel.updateSuggestionsArray(askFor: "")
            askForPicker.reloadAllComponents()
            self.askForPicker.selectRow(0, inComponent:0, animated:false)
            rModel.updateSuggestionsForCategory(title: pickerTitle)
            self.suggestionPicker.reloadAllComponents()
            self.suggestionPicker.selectRow(midPoint, inComponent:0, animated:false)
            
            askForLabel.text = "Spin for a random AskFor"
            suggestionLabel.text = "Spin for a random Suggestion"

            
            
        case askForPicker:
            guard let rModel = self.model else { return }
            let index = getInfiniteIndexForArrayWithALL(array: rModel.askForArray, row: row)
            let pickerTitle = rModel.askForArray[index]
            rModel.updateSuggestionsArray(askFor: pickerTitle)
            suggestionPicker.reloadAllComponents()
            self.suggestionPicker.selectRow(midPoint, inComponent:0, animated:false)
            askForLabel.text = pickerTitle
            suggestionLabel.text = "Spin for a random Suggestion"

            
        default:
            guard let rModel = self.model else { return }
            let index = row % rModel.suggestionsArray.count
            let suggestion = rModel.suggestionsArray[index]
            suggestionLabel.text = suggestion
        }
    }

}
extension RandomizerViewController {
    @objc func adjustConstraintsForOrientation() {
        if UIDevice.current.orientation.isLandscape {
           setLandscapeConstraints()
        } else {
           setPortraitConstraints()
        }
    }
}

// MARK: - private model update functions
private extension RandomizerViewController {
    
    func updatePickersForModels() {
        checkForEmptyModels()
        
        guard let rModel = self.model,
            let categoryModel = rModel.categoryModel,
            let askForModel = rModel.askForModel,
            let suggestionModel = rModel.suggestionModel else { return }
        
        let selectedCategoryRow = categoryPicker.selectedRow(inComponent: 0)
        categoryModel.currentCategory = categoryModel.categories[selectedCategoryRow] as? SceneCategory
        categoryModel.updateCategories()
        categoryPicker.reloadAllComponents()
        
        let selectedAskForRow = askForPicker.selectedRow(inComponent: 0)
        askForModel.currentCategory = categoryModel.currentCategory
        askForModel.updateAskFors()
        askForModel.currentAskFor = askForModel.currentCategory?.askFors?[selectedAskForRow] as? AskFor
        askForPicker.reloadAllComponents()
        
        suggestionModel.currentAskFor = askForModel.currentAskFor
        askForModel.updateSuggestions()
        suggestionPicker.reloadAllComponents()
    }
    
    func checkForEmptyModels() {
        guard let rModel = self.model,
            let categoryModel = rModel.categoryModel else { return }
        
        if categoryModel.categories.count == 0 {
            let emptyAlert = UIElementsManager.createAlertController(title: "No Category", message: "Please touch the Catalog tab and add at least one Category, AskFor, and Suggestion")
            DispatchQueue.main.async {
                self.present(emptyAlert, animated: true, completion: {})
            }
            return
        }
    }
}
