//
//  HomeView.swift
//  RelevantRecipesApp
//
//  Created by Сергеев Александр on 22.01.2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    
    
    var body: some View {
        TabView(selection: $viewModel.tabSelected) {
            RecipesView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Рецепты")
                }
                .tag(1)
            
            FavoriteView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Мои рецепты")
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Профиль")
                }
                .tag(3)
        }
        .environmentObject(viewModel)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
