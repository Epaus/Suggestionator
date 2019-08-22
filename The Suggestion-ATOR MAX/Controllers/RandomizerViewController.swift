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
   
    // MARK: - topPickerStackView elements
    private lazy var topPickerStackView: UIStackView = UIElementsManager.createUIStackView(width: UIElementSizes.windowWidth, height: UIElementSizes.windowHeight * 0.7, axis: .horizontal, distribution: .equalSpacing, alignment: .bottom, spacing: 0)
    private var categoryPicker =  UIElementsManager.createUIPickerView(borderWidth: 0, borderColor: .magenta, tintColor: .cyan, textColor: .black)
    private var askForPicker = UIElementsManager.createUIPickerView(borderWidth: 0, borderColor: .clear, tintColor: .clear, textColor: .black)
    private lazy var pinkBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundPink
        view.layer.cornerRadius = 0
        return view
    }()
    
    
    // MARK: - bottomPickerStackView elements
    private lazy var bottomPickerStackView: UIStackView = UIElementsManager.createUIStackView(width: UIElementSizes.windowWidth, height: UIElementSizes.windowHeight * 0.20, axis: .horizontal, distribution: .equalSpacing, alignment: .center, spacing: 0)
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
    var topPickerStackViewTopAnchor = NSLayoutConstraint()
    var topPickerStackViewLeadingAnchor = NSLayoutConstraint()
    var topPickerStackViewTrailingAnchor = NSLayoutConstraint()
    var labelViewTopAnchor = NSLayoutConstraint()
    var labelViewHeightAnchor = NSLayoutConstraint()
    var labelViewLeadingAnchor = NSLayoutConstraint()
    var labelViewTrailingAnchor = NSLayoutConstraint()
    var bottomPickerStackViewTopAnchor = NSLayoutConstraint()
    var bottomPickerStackViewLeadingAnchor = NSLayoutConstraint()
    var bottomPickerStackViewTrailingAnchor = NSLayoutConstraint()
    var bottomPickerStackViewBottomAnchor = NSLayoutConstraint()
   
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        NSLayoutConstraint.activate([
            askForLabel.leadingAnchor.constraint(equalTo: labelView.leadingAnchor, constant: 10),
            askForLabel.trailingAnchor.constraint(equalTo: labelView.trailingAnchor, constant: 10),
            askForLabel.centerYAnchor.constraint(equalTo: labelView.centerYAnchor, constant: -20),
            suggestionLabel.leadingAnchor.constraint(equalTo: labelView.leadingAnchor, constant: 10),
            suggestionLabel.trailingAnchor.constraint(equalTo: labelView.trailingAnchor, constant: 10),
            suggestionLabel.topAnchor.constraint(equalTo: askForLabel.bottomAnchor, constant: 10)
        ])
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
            askForPickerWidthConstraint,
            topPickerStackViewTopAnchor,
            topPickerStackViewLeadingAnchor,
            topPickerStackViewTrailingAnchor,
            labelViewTopAnchor,
            labelViewHeightAnchor,
            labelViewLeadingAnchor,
            labelViewTrailingAnchor,
            bottomPickerStackViewTopAnchor,
            bottomPickerStackViewLeadingAnchor,
            bottomPickerStackViewTrailingAnchor,
            bottomPickerStackViewBottomAnchor
        ])
        categoryPickerWidthConstraint = categoryPicker.widthAnchor.constraint(equalToConstant: UIElementSizes.windowWidth * 0.4)
        askForPickerWidthConstraint = askForPicker.widthAnchor.constraint(equalToConstant: UIElementSizes.windowWidth * 0.6)
        topPickerStackViewTopAnchor = topPickerStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0)
        topPickerStackViewLeadingAnchor = topPickerStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        topPickerStackViewTrailingAnchor = topPickerStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        labelViewTopAnchor = labelView.topAnchor.constraint(equalTo: topPickerStackView.bottomAnchor)
        labelViewHeightAnchor = labelView.heightAnchor.constraint(equalToConstant: UIElementSizes.windowHeight * 0.15)
        labelViewLeadingAnchor = labelView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        labelViewTrailingAnchor = labelView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        bottomPickerStackViewTopAnchor = bottomPickerStackView.topAnchor.constraint(equalTo: labelView.bottomAnchor)
        bottomPickerStackViewLeadingAnchor = bottomPickerStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        bottomPickerStackViewTrailingAnchor = bottomPickerStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        bottomPickerStackViewBottomAnchor = bottomPickerStackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        
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
        bottomPickerStackViewTopAnchor,
        bottomPickerStackViewLeadingAnchor,
        bottomPickerStackViewTrailingAnchor,
        bottomPickerStackViewBottomAnchor
           
            ])
    }
    
    func setLandscapeConstraints() {
        NSLayoutConstraint.deactivate([
            categoryPickerWidthConstraint,
            askForPickerWidthConstraint,
            topPickerStackViewTopAnchor,
            topPickerStackViewLeadingAnchor,
            topPickerStackViewTrailingAnchor,
            labelViewTopAnchor,
            labelViewHeightAnchor,
            labelViewLeadingAnchor,
            labelViewTrailingAnchor,
            bottomPickerStackViewTopAnchor,
            bottomPickerStackViewLeadingAnchor,
            bottomPickerStackViewTrailingAnchor,
            bottomPickerStackViewBottomAnchor
            ])
        categoryPickerWidthConstraint = categoryPicker.widthAnchor.constraint(equalToConstant: UIElementSizes.windowWidth * 0.4)
        askForPickerWidthConstraint = askForPicker.widthAnchor.constraint(equalToConstant: UIElementSizes.windowWidth * 0.3)
        topPickerStackViewTopAnchor = topPickerStackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20)
        topPickerStackViewLeadingAnchor = topPickerStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10)
        topPickerStackViewTrailingAnchor = topPickerStackView.trailingAnchor.constraint(equalTo: bottomPickerStackView.leadingAnchor, constant: 5)
        bottomPickerStackViewTopAnchor = bottomPickerStackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20)
        bottomPickerStackViewLeadingAnchor = bottomPickerStackView.leadingAnchor.constraint(equalTo: topPickerStackView.trailingAnchor, constant: 5)
        bottomPickerStackViewTrailingAnchor = bottomPickerStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 10)
        bottomPickerStackViewBottomAnchor = bottomPickerStackView.bottomAnchor.constraint(equalTo: labelView.topAnchor)
        labelViewTopAnchor = labelView.topAnchor.constraint(equalTo: bottomPickerStackView.bottomAnchor)
        labelViewLeadingAnchor = labelView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant:5)
        labelViewTrailingAnchor = labelView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 5)
        labelViewHeightAnchor = labelView.heightAnchor.constraint(equalToConstant: 100)
        
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
                bottomPickerStackViewTopAnchor,
                bottomPickerStackViewLeadingAnchor,
                bottomPickerStackViewTrailingAnchor,
                bottomPickerStackViewBottomAnchor
            ])
    }
    
    // MARK: - initializeModels
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
    @objc func adjustConstraintsForOrientation() {
        if UIDevice.current.orientation.isLandscape {
           setLandscapeConstraints()
        } else {
           setPortraitConstraints()
        }
    }
}
