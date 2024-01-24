//
//  MealType.swift
//  RelevantRecipesApp
//
//  Created by Сергеев Александр on 24.01.2024.
//

import Foundation

enum MealType: String, CaseIterable {
    case breakfast
    case brunch
    case lunchDinner = "lunch/dinner"
    case snack
    case teatime
}
