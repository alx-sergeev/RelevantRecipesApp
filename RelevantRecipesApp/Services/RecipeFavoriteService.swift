//
//  RecipeFavoriteService.swift
//  RelevantRecipesApp
//
//  Created by Сергеев Александр on 23.01.2024.
//

import Foundation
import CoreData

class RecipeFavoriteService: ObservableObject {
    
    let container: NSPersistentContainer
    private let containerName = "RecipeContainer"
    private let entityName = "RecipeEntity"
    
    @Published var entityItems: [RecipeEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error loading Core Data! \(error.localizedDescription)")
            }
            
            self.fetchItems()
        }
    }
    
    // MARK: - Public
    
    func add(recipe: Recipe) {
        let entity = RecipeEntity(context: container.viewContext)
        entity.label = recipe.label
        entity.image = recipe.image
        entity.url = recipe.url
        entity.mealType = recipe.mealTypeList
        entity.cuisineType = recipe.cuisineTypeList
        
        applyChanges()
    }
    
    func delete(recipe: Recipe) {
        let entities = entityItems.filter{ $0.label == recipe.label }
        guard !entities.isEmpty else { return }
        
        for entity in entities {
            container.viewContext.delete(entity)
        }
        applyChanges()
    }
    
    // MARK: - Private
    
    private func fetchItems() {
        let request = NSFetchRequest<RecipeEntity>(entityName: entityName)
        
        do {
            entityItems = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching Portfolio Entities. \(error.localizedDescription)")
        }
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving to Core Data. \(error.localizedDescription)")
        }
    }
    
    private func applyChanges() {
        save()
        fetchItems()
    }
}
