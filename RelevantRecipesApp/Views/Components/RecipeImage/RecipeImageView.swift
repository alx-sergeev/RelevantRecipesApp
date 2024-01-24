//
//  RecipeImageView.swift
//  RelevantRecipesApp
//
//  Created by Сергеев Александр on 23.01.2024.
//

import SwiftUI

struct RecipeImageView: View {
    @StateObject var viewModel: RecipeImageViewModel
    
    
    init(recipe: Recipe) {
        _viewModel = StateObject(wrappedValue: RecipeImageViewModel(recipe: recipe))
    }
    
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if viewModel.isLoading {
                ProgressView()
            } else {
                Image(systemName: "carrot.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.theme.accent)
            }
        }
    }
}

struct RecipeImageView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeImageView(recipe: Recipe(label: nil, image: nil, url: nil, cuisineType: nil, mealType: nil))
    }
}
