//
//  HomeViewModel.swift
//  RelevantRecipesApp
//
//  Created by Сергеев Александр on 24.01.2024.
//

import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var tabSelected = 1
    @AppStorage("userName") var nameTextField = ""
    @AppStorage("userDiet") var currentDiet = ""
    
    private let favoriteService = RecipeFavoriteService()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var favoriteItems: [Recipe] = []
    @Published var filteredFavoriteItems: [Recipe] = []
    
    private(set) var mealTypes: [MealType] = []
    @Published var mealTypeSelected: MealType?
    
    private(set) var cuisineTypes: [CuisineType] = []
    @Published var cuisineTypeSelected: CuisineType?
    
    
    init() {
        choiceTabSelected()
        
        createMealTypes()
        createCuisineTypes()
        
        addSubscribers()
    }
    
    
    // Public
    
    func addToFavorite(recipe: Recipe) {
        favoriteService.add(recipe: recipe)
    }
    
    func deleteFromFavorite(recipe: Recipe) {
        favoriteService.delete(recipe: recipe)
    }
    
    func deleteAction(offsets: IndexSet) {
        guard let item = offsets.first else { return }
        
        let recipe = favoriteItems[item]
        favoriteService.delete(recipe: recipe)
        
        favoriteItems.remove(atOffsets: offsets)
        filteredFavoriteItems.remove(atOffsets: offsets)
    }
    
    
    func isExistInFavorite(recipe: Recipe) -> Bool {
        return favoriteItems.contains(where: { $0.label == recipe.label })
    }
    
    func setMealType(_ type: MealType?) {
        mealTypeSelected = type
        filteredApply()
    }
    
    func setCuisineType(_ type: CuisineType?) {
        cuisineTypeSelected = type
        filteredApply()
    }
    
    // Private
    
    private func choiceTabSelected() {
        if nameTextField.isEmpty || currentDiet.isEmpty {
            DispatchQueue.main.async { [weak self] in
                self?.tabSelected = HomeViewModel.TabSelected.profile.rawValue
            }
        }
    }
    
    private func filteredApply() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.filteredFavoriteItems = self.filterFavoriteRecipesIfNeeded()
        }
    }
    
    private func createMealTypes() {
        mealTypes = MealType.allCases.map { $0 }
    }
    
    private func createCuisineTypes() {
        cuisineTypes = CuisineType.allCases.map { $0 }
    }
    
    private func addSubscribers() {
        favoriteService.$entityItems
            .map(mapEntityItems)
            .sink { [weak self] (returnedRecipes) in
                guard let self = self else { return }
                
                self.favoriteItems = returnedRecipes
                self.filteredFavoriteItems = returnedRecipes
            }
            .store(in: &cancellables)
    }
    
    private func mapEntityItems(recipeEntities: [RecipeEntity]) -> [Recipe] {
        recipeEntities.map { entity -> Recipe in
            return Recipe.createRecipeFromEntity(entity: entity)
        }
    }
    
    func filterFavoriteRecipesIfNeeded() -> [Recipe] {
        guard !favoriteItems.isEmpty else { return [] }
        
        var filterItems: [Recipe] = favoriteItems
        let selectedItems = (mealTypeSelected, cuisineTypeSelected)
        
        switch selectedItems {
        case (let mealType, nil):
            if let mealType = mealType {
                filterItems = filterItems.filter({ $0.mealTypeList?.contains(mealType.rawValue) ?? false })
            }
        case (nil, let cuisineType):
            if let cuisineType = cuisineType {
                filterItems = filterItems.filter({ $0.cuisineTypeList?.contains(cuisineType.rawValue) ?? false })
            }
        case let (mealType, cuisineType):
            if let mealType = mealType, let cuisineType = cuisineType {
                filterItems = filterItems
                    .filter({ $0.mealTypeList?.contains(mealType.rawValue) ?? false })
                    .filter({ $0.cuisineTypeList?.contains(cuisineType.rawValue) ?? false })
            }
        }
        
        return filterItems
    }
}

// MARK: - enum TabSelected
extension HomeViewModel {
    enum TabSelected: Int {
        case home = 1, favorite, profile
    }
}
