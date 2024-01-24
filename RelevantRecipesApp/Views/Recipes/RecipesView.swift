//
//  ResipesView.swift
//  RelevantRecipesApp
//
//  Created by Сергеев Александр on 22.01.2024.
//

import SwiftUI

struct RecipesView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    
    @StateObject private var viewModel = RecipesViewModel()
    
    var body: some View {
        VStack(spacing: 50) {
            Picker("The type of cuisine", selection: $viewModel.cuisineSelectedType) {
                ForEach(viewModel.cuisineTypes, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .pickerStyle(.segmented)
            
            if viewModel.recipes.isEmpty {
                Text("No records found")
                    .foregroundColor(.theme.accent)
            } else {
                recipeList
            }
            
            Spacer()
        }
    }
}

// MARK: - Additional views
extension RecipesView {
    private var recipeList: some View {
        List {
            ForEach(viewModel.recipes, id: \.self) { item in
                let isExistInFavorite = homeVM.isExistInFavorite(recipe: item)
                RecipeRowView(item: item, isFavorite: isExistInFavorite)
            }
            
            if viewModel.canLoadMorePages {
                ProgressView()
                    .listRowInsets(EdgeInsets())
                    .frame(maxWidth: .infinity, minHeight: 60)
                    .onAppear {
                        viewModel.loadNextPage()
                    }
            }
        }
        .listStyle(.plain)
    }
}

struct ResipesView_Previews: PreviewProvider {
    static var previews: some View {
        RecipesView()
    }
}
