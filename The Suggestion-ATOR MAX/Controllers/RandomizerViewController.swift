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
        initializeModels()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundPink
        if let statusbarView = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusbarView.backgroundColor = .backgroundPink
        }
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        NotificationCenter.default.addObserver(self, selector: #selector(adjustConstraintsForOrientation), name: UIDevice.orientationDidChangeNotification, object: nil)
        self.view.backgroundColor = .white
        configureLabelView()
        configurePickers()
        adjustConstraintsForOrientation()
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
    
    // MARK: - initializeModels
    func initializeModels() {
        guard let rModel = self.model,
            let categoryModel = rModel.categoryModel,
            let askForModel = rModel.askForModel,
            let suggestionModel = rModel.suggestionModel else { return }
        if categoryModel.categories.count == 0 {
            let emptyAlert = UIElementsManager.createAlertController(title: "No Category", message: "Please touch the Catalog tab and add at least one Category, AskFor, and Suggestion")
            DispatchQueue.main.async {
                self.present(emptyAlert, animated: true, completion: {})
            }
            return
        }
        
        categoryModel.currentCategory = categoryModel.categories[0] as? SceneCategory
        categoryModel.updateCategories()
        categoryPicker.reloadAllComponents()
        categoryPicker.selectRow(0, inComponent:0, animated:false)
        askForModel.currentCategory = categoryModel.categories[0] as? SceneCategory
        askForModel.updateAskFors()
        askForModel.currentAskFor = askForModel.currentCategory?.askFors?[0] as? AskFor
        askForPicker.reloadAllComponents()
        askForModel.updateSuggestions()
        suggestionModel.currentAskFor = askForModel.currentAskFor
        suggestionPicker.reloadAllComponents()
    }
    
    // MARK: - PickerView delegate and datasource functions
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
        case askForPicker:
            guard let model = self.model?.categoryModel,
                let askFor = model.currentCategory?.askFors?[row] as? AskFor else { return "" }
            title = askFor.askFor
        case suggestionPicker:
            guard let model = self.model?.askForModel,
            let askFor = model.currentAskFor,
                let suggestion = askFor.suggestions?[row] as? Suggestion else { return "" }
            title = suggestion.suggestion
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
                let _ = rModel.categoryModel,
                let askForModel = rModel.askForModel else { return }
            let suggestion = askForModel.currentAskFor?.suggestions?[row] as? Suggestion
            suggestionLabel.text = suggestion?.suggestion
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
