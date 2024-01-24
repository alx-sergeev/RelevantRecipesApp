//
//  Recipe.swift
//  RelevantRecipesApp
//
//  Created by Сергеев Александр on 22.01.2024.
//

import Foundation

// MARK: - RecipeData
struct RecipeData: Codable {
    let from, to, count: Int?
    let links: Links?
    let hits: [Hit]?
    
    enum CodingKeys: String, CodingKey {
        case from, to, count
        case links = "_links"
        case hits
    }
}

// MARK: - Links
struct Links: Codable {
    let next: Next?
}

// MARK: - Next
struct Next: Codable {
    let href: String?
    let title: String?
}

// MARK: - Hit
struct Hit: Codable {
    let recipe: Recipe?
}

// MARK: - Recipe
struct Recipe: Codable, Hashable {
    let label: String?
    let image: String?
    let url: String?
    let cuisineType: [String]?
    let mealType: [String]?
    
    var cuisineTypeList: String? {
        cuisineType?.joined(separator: ", ")
    }
    
    var mealTypeList: String? {
        mealType?.joined(separator: ", ")
    }
    
    static func createRecipeFromEntity(entity: RecipeEntity) -> Self {
        let arrCuisineType: [String]? = [entity.cuisineType ?? ""]
        let arrMealType: [String]? = [entity.mealType ?? ""]
        let newRecipe = Recipe(
            label: entity.label,
            image: entity.image,
            url: entity.url,
            cuisineType: arrCuisineType,
            mealType: arrMealType
        )
        
        return newRecipe
    }
}
