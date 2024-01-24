//
//  UserDiet.swift
//  RelevantRecipesApp
//
//  Created by Сергеев Александр on 23.01.2024.
//

import Foundation

enum UserDiet: String, CaseIterable {
    case balanced
    case highFiber = "high-fiber"
    case highProtein = "high-protein"
    case lowCarb = "low-carb"
    case lowFat = "low-fat"
    case lowSodium = "low-sodium"
}
