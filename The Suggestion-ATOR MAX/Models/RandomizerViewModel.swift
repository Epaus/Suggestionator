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
    var askForModel: AskForModel?
    var suggestionModel: SuggestionModel?
   
    
    init(categoryModel: SceneCategoryModel, askForModel: AskForModel, suggestionModel: SuggestionModel) {
        self.categoryModel = categoryModel
        self.askForModel = askForModel
        self.suggestionModel = suggestionModel
    }
}
