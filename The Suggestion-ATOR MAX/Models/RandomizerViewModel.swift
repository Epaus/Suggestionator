//
//  RandomizerViewModel.swift
//  The Suggestion-ATOR MAX
//
//  Created by Estelle Paus on 8/11/19.
//  Copyright © 2019 Paus Productions. All rights reserved.
//

import Foundation
import CoreData
import os.log

class RandomizerViewModel {
    
    var categoryModel: SceneCategoryModel?
    var currentCategory: SceneCategory?
    var askForModel: AskForModel?
    var suggestionModel: SuggestionModel?
    
    var categoryArray = ["ALL"]
    var askForArray = ["ALL"]
    var suggestionsArray = [String]()
   
    
    init(categoryModel: SceneCategoryModel, askForModel: AskForModel, suggestionModel: SuggestionModel) {
        self.categoryModel = categoryModel
        self.askForModel = askForModel
        self.suggestionModel = suggestionModel
    }
    
    func initializeModels(completion: (() -> Void)?) {
        
       if let cModel = categoryModel,
        let aModel = askForModel,
        let sModel = suggestionModel {
        
        cModel.currentCategory = nil
        cModel.updateCategories()
       
        aModel.currentCategory = nil
        aModel.updateAskFors()
        askForArray = convertAskForsObjectArrayToStringArray(moArray: aModel.askFors )
       
        sModel.currentAskFor = nil
        sModel.updateSuggestions()
        suggestionsArray = convertSuggestionObjectArrayToStringArray(moArray: sModel.suggestions)
        }
        guard let complete = completion else { return }
        complete()
       
    }
    
    func populateArrays() {
        guard let cModel = categoryModel,
         let aModel = askForModel,
         let sModel = suggestionModel else { return }
        let categories = cModel.categories
        for category in categories {
            if let cat = category as? SceneCategory {
                categoryArray.append(cat.title ?? "")
            }
        }
        let askFors = aModel.askFors
        for askFor in askFors {
            if let askF = askFor as? AskFor {
                askForArray.append(askF.askFor ?? "")
            }
        }
        
        let suggestions = sModel.suggestions
        suggestionsArray = convertSuggestionObjectArrayToStringArray(moArray: suggestions)
    }
    
    func convertSuggestionObjectArrayToStringArray(moArray: [NSManagedObject]) -> [String] {
        var tempArray = [String]()
        for suggestion in moArray {
            if let suggestion = suggestion as? Suggestion {
                tempArray.append(suggestion.suggestion ?? "")
            }
        }
        return tempArray
    }
    
    func updateSuggestionsArray(askFor: String) {
        if let  tempArray = askForModel?.suggestionsForAskFor(askFor: askFor) {
            suggestionsArray = convertSuggestionObjectArrayToStringArray(moArray: tempArray)
        }
    }
    
    func convertAskForsObjectArrayToStringArray(moArray: [NSManagedObject]) -> [String] {
        var tempArray = ["ALL"]
        for askFor in moArray {
            if let askFor = askFor as? AskFor {
                tempArray.append(askFor.askFor ?? "")
            }
        }
        return tempArray
    }
    
    func updateAskForArray(category: String) {
        if let tempArray = categoryModel?.askForsForCategory(category: category) {
            askForArray = convertAskForsObjectArrayToStringArray(moArray: tempArray)
        }
    }
    
    func categoryForTitle(title: String) -> SceneCategory {
        guard let catModel = categoryModel else { return SceneCategory() }
        return catModel.categoryForString(title: title)
    }
    
    func askForForTitle(title: String) -> AskFor {
        guard let askForModel = askForModel else { return AskFor() }
        return askForModel.askForForString(title: title)
    }
    
    func deleteBadAskFors() {
        let askFor = askForForTitle(title: "clergy/parishioner")
        guard let askForModel = askForModel else { return  }
        askForModel.delete(askFor: askFor, completion: nil)
    }
    
    func updateSuggestionsForCategory(title: String)  {
        suggestionsArray = [String]()
        let category = categoryForTitle(title: title)
        categoryModel?.currentCategory = category
        if title == "ALL" {
            initializeModels(completion: {
                print("ALL category - what to do now?")
            })
        } else {
            guard let askFors = categoryModel?.currentCategory?.askFors else { return }
            
            
            for askFor in askFors {
                let askF = askFor as? AskFor
                if let  tempArray = askForModel?.suggestionsForAskFor(askFor: askF?.askFor ?? "") {
                    for suggestion in tempArray {
                        suggestionsArray.append(suggestion.suggestion ?? "")
                    }
                }
            }
        }
    }
}
