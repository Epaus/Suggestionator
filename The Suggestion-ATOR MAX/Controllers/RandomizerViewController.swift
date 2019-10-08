//
//  RandomizerViewController.swift
//  The Suggestion-ATOR MAX
//
//  Created by Estelle Paus on 7/28/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import UIKit
import CoreData
import os.log

class RandomizerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   
    var model: RandomizerViewModel? = nil
    let numRows = 200000
    var bigSpin = false
    
   
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
    private let askForSpinnerButton = UIElementsManager.createButton(text: "Spin for a random AskFor", font: .boldSystemFont(ofSize: 22), titleColor: .pink, backgroundColor: .clear, borderWidth:  0, borderColor: .clear, cornerRadius: 0, textAlignment: .center)
    
    private let suggestionSpinnerButton = UIElementsManager.createButton(text: "Spin for a random Suggestion", font: .boldSystemFont(ofSize: 22), titleColor: .backgroundBlue, backgroundColor: .clear, borderWidth: 0, borderColor: .clear, cornerRadius: 0, textAlignment: .center)
    
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
    var askForSpinnerButtonCenterYAnchor = NSLayoutConstraint()
    var askForSpinnerButtonLeadingAnchor = NSLayoutConstraint()
    var askForSpinnerButtonTrailingAnchor = NSLayoutConstraint()
    var suggestionSpinnerButtonCenterYAnchor = NSLayoutConstraint()
    var suggestionSpinnerButtonLeadingAnchor = NSLayoutConstraint()
    var suggestionSpinnerButtonTrailingAnchor = NSLayoutConstraint()
   
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
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
        askForSpinnerButton.tag = 0
        askForSpinnerButton.addTarget(self, action: #selector(spinPicker(sender:)), for: .touchUpInside)
        suggestionSpinnerButton.tag = 1
        suggestionSpinnerButton.addTarget(self, action: #selector(spinPicker(sender:)), for: .touchUpInside)
        
        adjustConstraintsForOrientation()
        checkForEmptyModels()
//        guard let vm = model else { return }
//        vm.initializeModels(completion: {
//            vm.populateArrays()
//            self.categoryPicker.reloadAllComponents()
//            self.categoryPicker.selectRow(0, inComponent:0, animated:false)
//            self.askForPicker.reloadAllComponents()
//            self.askForPicker.selectRow(0, inComponent:0, animated:false)
//            self.suggestionPicker.reloadAllComponents()
//            self.suggestionPicker.selectRow(500, inComponent:0, animated:false)
//        })
    }
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Configure views
    private func configureLabelView() {
        labelView.addSubview(askForSpinnerButton)
        labelView.addSubview(suggestionSpinnerButton)
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
            askForSpinnerButtonCenterYAnchor,
            askForSpinnerButtonLeadingAnchor,
            askForSpinnerButtonTrailingAnchor,
            suggestionSpinnerButtonCenterYAnchor,
            suggestionSpinnerButtonLeadingAnchor,
            suggestionSpinnerButtonTrailingAnchor
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
        askForSpinnerButtonCenterYAnchor = askForSpinnerButton.centerYAnchor.constraint(equalTo: labelView.centerYAnchor, constant: -20)
        askForSpinnerButtonLeadingAnchor = askForSpinnerButton.leadingAnchor.constraint(equalTo: labelView.leadingAnchor, constant: 10)
        askForSpinnerButtonTrailingAnchor = askForSpinnerButton.trailingAnchor.constraint(equalTo: labelView.trailingAnchor, constant: -10)
        suggestionSpinnerButtonCenterYAnchor = suggestionSpinnerButton.centerYAnchor.constraint(equalTo: labelView.centerYAnchor, constant: 20)
        suggestionSpinnerButtonLeadingAnchor = suggestionSpinnerButton.leadingAnchor.constraint(equalTo: labelView.leadingAnchor, constant: 10)
        suggestionSpinnerButtonTrailingAnchor = suggestionSpinnerButton.trailingAnchor.constraint(equalTo: labelView.trailingAnchor, constant: -10)
        
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
        askForSpinnerButtonTrailingAnchor,
        askForSpinnerButtonLeadingAnchor,
        askForSpinnerButtonCenterYAnchor,
        suggestionSpinnerButtonTrailingAnchor,
        suggestionSpinnerButtonLeadingAnchor,
        suggestionSpinnerButtonCenterYAnchor
           
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
        askForSpinnerButtonCenterYAnchor = askForSpinnerButton.centerYAnchor.constraint(equalTo: labelView.centerYAnchor, constant: -20)
        askForSpinnerButtonLeadingAnchor = askForSpinnerButton.leadingAnchor.constraint(equalTo: labelView.leadingAnchor, constant: 10)
        askForSpinnerButtonTrailingAnchor = askForSpinnerButton.trailingAnchor.constraint(equalTo: labelView.trailingAnchor, constant: -10)
        suggestionSpinnerButtonCenterYAnchor = suggestionSpinnerButton.centerYAnchor.constraint(equalTo: labelView.centerYAnchor, constant: 20)
        suggestionSpinnerButtonLeadingAnchor = suggestionSpinnerButton.leadingAnchor.constraint(equalTo: labelView.leadingAnchor, constant: 10)
        suggestionSpinnerButtonTrailingAnchor = suggestionSpinnerButton.trailingAnchor.constraint(equalTo: labelView.trailingAnchor, constant: -10)
        
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
                askForSpinnerButtonCenterYAnchor,
                askForSpinnerButtonLeadingAnchor,
                askForSpinnerButtonTrailingAnchor,
                suggestionSpinnerButtonCenterYAnchor,
                suggestionSpinnerButtonLeadingAnchor,
                suggestionSpinnerButtonTrailingAnchor
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
            return numRows
            
        default:
            return numRows
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
            var index = 0
            if model.suggestionsArray.count > 0 {
                index = row % model.suggestionsArray.count
                 title = model.suggestionsArray[index]
            } else {
                title = ""
            }
           
        default:
            os_log("titleForRow pickerView = %@ - how did we get here?", pickerView)
        }
       
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
            didSelectCategory(row: row)
            
        case askForPicker:
            didSelectAskFor(row: row)
           
        default:
          didSelectSuggestion(row: row)
        }
    }
    
    func didSelectCategory(row: Int) {
        guard let rModel = self.model else { return }
        let pickerTitle = rModel.categoryArray[row]
        rModel.currentCategory = (row != 0) ? rModel.categoryForTitle(title: pickerTitle) : nil
        
        rModel.updateAskForArray(category: rModel.currentCategory?.title ?? "")
        rModel.updateSuggestionsArray(askFor: "")
        askForPicker.reloadAllComponents()
        self.askForPicker.selectRow(0, inComponent:0, animated:false)
        rModel.updateSuggestionsForCategory(title: pickerTitle)
        self.suggestionPicker.reloadAllComponents()
        let midPoint = (numRows % rModel.suggestionsArray.count) + numRows/2
        self.suggestionPicker.selectRow(midPoint, inComponent:0, animated:false)
        
        askForSpinnerButton.setTitle("Spin for a random AskFor", for: .normal)
        suggestionSpinnerButton.setTitle("Spin for a random Suggestion", for: .normal   )
    }
    
    func didSelectAskFor(row: Int) {
        guard let rModel = self.model else { return }
        let index = getInfiniteIndexForArrayWithALL(array: rModel.askForArray, row: row)
        let pickerTitle = rModel.askForArray[index] == "ALL" ? "" : rModel.askForArray[index]
        if pickerTitle == "" {
            rModel.updateSuggestionsForCategory(title: rModel.currentCategory?.title ?? "")
            askForSpinnerButton.setTitle("Spin for a random AskFor", for: .normal)
        } else {
            rModel.updateSuggestionsArray(askFor: pickerTitle)
            askForSpinnerButton.setTitle(pickerTitle, for: .normal)
        }
        askForSpinnerButton.setNeedsLayout()
        suggestionPicker.reloadAllComponents()
        if rModel.suggestionsArray.count > 0 {
            let midPoint = (numRows % rModel.suggestionsArray.count) + numRows/2
            self.suggestionPicker.selectRow(midPoint, inComponent:0, animated:false)
        }
       
        suggestionSpinnerButton.setTitle("Spin for a random Suggestion", for: .normal)
    }
    
    func didSelectSuggestion(row: Int) {
        guard let rModel = self.model else { return }
        let index = row % rModel.suggestionsArray.count
        let suggestion = rModel.suggestionsArray[index]
        suggestionSpinnerButton.setTitle(suggestion, for: .normal)
    }
}

@objc extension RandomizerViewController {
    func adjustConstraintsForOrientation() {
        if UIDevice.current.orientation.isLandscape {
           setLandscapeConstraints()
        } else {
           setPortraitConstraints()
        }
    }
    
    
    func spinPicker(sender: UIButton)  {
        guard let rModel = model else { return }
        
        switch sender.tag {
        case 0:
            let count = rModel.askForArray.count
            let picker = askForPicker
            let index = getRandomIndex(size: count)
            DispatchQueue.main.async {
                picker.selectRow(index, inComponent: 0, animated: true)
                self.didSelectAskFor(row: index)
                picker.showsSelectionIndicator = true
            }
           
        case 1:
            let count = rModel.suggestionsArray.count
            let picker = suggestionPicker
            let index = getRandomIndex(size: count)
            DispatchQueue.main.async {
                picker.selectRow(index, inComponent: 0, animated: true)
                self.didSelectSuggestion(row: index)
                picker.showsSelectionIndicator = true
            }
            
        default:
            os_log("spinPicker tag = %d - how did we get here?", sender.tag)
        }
      
    }
    
    func getRandomIndex(size: Int) -> Int {
        let random = arc4random()
        let position = Int(random) % size
        let index =  (bigSpin == true ) ? ( 1000 * size + position) : ( size + position)
        bigSpin.toggle()
        return index
    }
    
}

// MARK: - private model update functions
private extension RandomizerViewController {
    
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
