//
//  FavoriteView.swift
//  RelevantRecipesApp
//
//  Created by Сергеев Александр on 22.01.2024.
//

import SwiftUI

struct FavoriteView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    
    @State private var isEditing = false
    
    var body: some View {
        NavigationView {
            content
                .environment(\.editMode, .constant(isEditing ? EditMode.active : EditMode.inactive))
                .animation(.spring(), value: isEditing)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            isEditing.toggle()
                        }) {
                            if isEditing {
                                Image(systemName: "checkmark")
                            } else {
                                Image(systemName: "pencil")
                            }
                        }
                    }
                }
        }
    }
    
    private var content: some View {
        VStack(spacing: 40) {
            topMenuView
            favoriteListView
            Spacer()
        }
    }
}

// MARK: - Additional views
extension FavoriteView {
    private var topMenuView: some View {
        HStack {
            VStack(alignment: .leading) {
                Menu("Meal type") {
                    Button("-") {
                        setMealType(nil)
                    }
                    
                    ForEach(homeVM.mealTypes, id: \.self) { mealType in
                        Button(mealType.rawValue) {
                            setMealType(mealType)
                        }
                    }
                }
                
                Spacer()
                
                if let mealTypeSelected = homeVM.mealTypeSelected {
                    Text(mealTypeSelected.rawValue)
                }
            }
            
            VStack(alignment: .leading) {
                Menu("Cuisine type") {
                    Button("-") {
                        setCuisineType(nil)
                    }
                    
                    ForEach(homeVM.cuisineTypes, id: \.self) { cuisineType in
                        Button(cuisineType.rawValue) {
                            setCuisineType(cuisineType)
                        }
                    }
                }
                
                Spacer()
                
                if let cuisineTypeSelected = homeVM.cuisineTypeSelected {
                    Text(cuisineTypeSelected.rawValue)
                }
            }
        }
        .frame(height: 45)
    }
    
    private var favoriteListView: some View {
        ZStack {
            if homeVM.filteredFavoriteItems.isEmpty {
                Text("No records found")
                    .foregroundColor(.theme.accent)
            } else {
                List {
                    ForEach(homeVM.filteredFavoriteItems, id: \.self) { item in
                        FavoriteRowView(item: item)
                    }
                    .onDelete(perform: onDelete)
                }
                .listStyle(.plain)
            }
        }
    }
}

// MARK: - Actions
extension FavoriteView {
    private func onDelete(offsets: IndexSet) {
        homeVM.deleteAction(offsets: offsets)
    }
    
    private func setMealType(_ type: MealType?) {
        homeVM.setMealType(type)
    }
    
    private func setCuisineType(_ type: CuisineType?) {
        homeVM.setCuisineType(type)
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView()
            .environmentObject(HomeViewModel())
    }
}
