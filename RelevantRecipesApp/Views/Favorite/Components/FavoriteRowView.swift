//
//  FavoriteRowView.swift
//  RelevantRecipesApp
//
//  Created by Сергеев Александр on 24.01.2024.
//

import SwiftUI

struct FavoriteRowView: View {
    let item: Recipe
    
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
            
            Text(item.cuisineTypeList ?? "")
        }
    }
}

struct FavoriteRowView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteRowView(item: Recipe(label: nil, image: nil, url: nil, cuisineType: nil, mealType: nil))
    }
}
