//
//  ImageService.swift
//  RelevantRecipesApp
//
//  Created by Сергеев Александр on 23.01.2024.
//

import SwiftUI
import Combine

class ImageService {
    private let recipe: Recipe
    
    private var imageSubscription: AnyCancellable?
    private let folderName = "recipe_images"
    private let imageName: String
    
    @Published var image: UIImage?
    
    
    init(recipe: Recipe) {
        self.recipe = recipe
        imageName = UUID().uuidString
        
        downloadImage()
    }
    
    
    private func downloadImage() {
        guard let urlString = recipe.image, let url = URL(string: urlString) else { return }
        
        imageSubscription = NetworkManager.download(url: url)
            .tryMap { (data) -> UIImage? in
                return UIImage(data: data)
            }
            .sink(receiveCompletion: NetworkManager.handleCompletion) { [weak self] (returnedImage) in
                guard let self = self, let downloadedImage = returnedImage else { return }
                
                self.image = downloadedImage
                self.imageSubscription?.cancel()
            }
    }
}
