//
//  ApiService.swift
//  RelevantRecipesApp
//
//  Created by Сергеев Александр on 22.01.2024.
//

import Foundation
import Combine

final class ApiService {
    static let shared = ApiService()
    private init() {}
    
    private let appID = "78247fe1"
    private let apiKEY = "88156bf17bae4acba76007ac1db629d7"
    private var cancellables = Set<AnyCancellable>()
    
    @Published var recipeData: RecipeData?
    
    
    func recipeGetList(diet: String, cuisine: String) {
        guard let url = URL(string: "https://api.edamam.com/api/recipes/v2?type=public&app_id=\(appID)&app_key=\(apiKEY)&diet=\(diet)&cuisineType=\(cuisine)&imageSize=SMALL&field=label&field=image&field=url&field=uri&field=cuisineType&field=mealType") else {
            return
        }
        
        NetworkManager.download(url: url)
            .decode(type: RecipeData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion) { [weak self] recipeData in
                self?.recipeData = recipeData
            }
            .store(in: &cancellables)
    }
    
    func recipeNextList(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        NetworkManager.download(url: url)
            .decode(type: RecipeData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion) { [weak self] recipeData in
                self?.recipeData = recipeData
            }
            .store(in: &cancellables)
    }
}
