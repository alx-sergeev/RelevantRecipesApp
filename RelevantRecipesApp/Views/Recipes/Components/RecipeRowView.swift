//
//  RecipeRowView.swift
//  RelevantRecipesApp
//
//  Created by Сергеев Александр on 23.01.2024.
//

import SwiftUI

struct RecipeRowView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    
    let item: Recipe
    @State var isFavorite: Bool = false
    
    var body: some View {
        ZStack {
            if let urlString = item.url, let url = URL(string: urlString) {
                Link(destination: url) {
                    content
                }
            } else {
                content
            }
        }
    }
    
    var content: some View {
        VStack(alignment:. leading, spacing: 20) {
            RecipeImageView(recipe: item)
                .frame(maxWidth: .infinity)
                .frame(height: 200)
            
            Text(item.label ?? "")
            
            Text(item.mealTypeList ?? "")
            
            Button(action: favoriteRecipeAction) {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .foregroundColor(.yellow)
            }
        }
    }
}

struct RecipeRowView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeRowView(item: .init(label: nil, image: nil, url: nil, cuisineType: nil, mealType: nil), isFavorite: false)
    }
}

// MARK: - Actions
extension RecipeRowView {
    func favoriteRecipeAction() {
        isFavorite.toggle()
        
        if isFavorite {
            homeVM.addToFavorite(recipe: item)
        } else {
            homeVM.deleteFromFavorite(recipe: item)
        }
    }
}
