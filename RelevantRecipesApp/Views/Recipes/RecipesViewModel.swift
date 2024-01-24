//
//  RecipesViewModel.swift
//  RelevantRecipesApp
//
//  Created by Сергеев Александр on 22.01.2024.
//

import SwiftUI
import Combine

class RecipesViewModel: ObservableObject {
    private let apiService = ApiService.shared
    
    @AppStorage("userDiet") var currentDiet: String?
    private var cancellables = Set<AnyCancellable>()
    
    @Published var cuisineTypes: [CuisineType] = []
    @Published var cuisineSelectedType: CuisineType = .asian
    
    @Published var recipes: [Recipe] = []
    
    private var pageTo = 0
    private var pageCount = 0
    private var urlNextPage = ""
    var canLoadMorePages: Bool {
        if pageTo == 0, pageCount == 0, urlNextPage.isEmpty {
            return false
        }
        return (pageTo < pageCount) && !urlNextPage.isEmpty
    }
    
    
    init() {
        createCuisineTypes()
        addSubscribers()
    }
    
    
    func loadNextPage() {
        guard canLoadMorePages == true, !urlNextPage.isEmpty else { return }
        
        apiService.recipeNextList(urlString: urlNextPage)
    }
    
    private func clearPaginationData() {
        DispatchQueue.main.async { [weak self] in
            self?.recipes.removeAll()
        }
        
        pageTo = 0
        pageCount = 0
        urlNextPage = ""
    }
    
    private func createCuisineTypes() {
        cuisineTypes = CuisineType.allCases.map { $0 }
    }
    
    private func recipeGetList(diet: String, cuisine: String) {
        apiService.recipeGetList(diet: diet, cuisine: cuisine)
    }
    
    private func addSubscribers() {
        $cuisineSelectedType
            .sink { [weak self] cuisineType in
                self?.clearPaginationData()
                self?.recipeGetList(diet: self?.currentDiet ?? "", cuisine: cuisineType.rawValue)
            }
            .store(in: &cancellables)
        
        apiService.$recipeData
            .dropFirst()
            .sink { [weak self] recipeData in
                guard let self = self, let recipeHits = recipeData?.hits else { return }
                
                let returnedRecipe = recipeHits.compactMap { $0.recipe }
                let newRecipe = returnedRecipe.filter { item -> Bool in
                    return !self.recipes.contains(where: { $0.label == item.label })
                }
                
                if !newRecipe.isEmpty {
                    self.recipes += newRecipe
                }
                
                // Pagination
                self.pageTo = recipeData?.to ?? 0
                self.pageCount = recipeData?.count ?? 0
                self.urlNextPage = recipeData?.links?.next?.href ?? ""
            }
            .store(in: &cancellables)
    }
}
