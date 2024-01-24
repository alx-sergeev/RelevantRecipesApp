//
//  RecipeImageViewModel.swift
//  RelevantRecipesApp
//
//  Created by Сергеев Александр on 23.01.2024.
//

import SwiftUI
import Combine

class RecipeImageViewModel: ObservableObject {
    private let recipe: Recipe
    private let dataService: ImageService
    private var cancellables = Set<AnyCancellable>()
    
    @Published var image: UIImage?
    @Published var isLoading = false
    
    
    init(recipe: Recipe) {
        self.recipe = recipe
        
        self.dataService = ImageService(recipe: recipe)
        
        self.addSubscribers()
        self.isLoading = true
    }
    
    
    private func addSubscribers() {
        dataService.$image
            .sink { [weak self] _ in
                self?.isLoading = false
            } receiveValue: { [weak self] (returnedImage) in
                self?.image = returnedImage
            }
            .store(in: &cancellables)

    }
}
