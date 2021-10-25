//
//  StorageManager.swift
//  ExpirationTracker
//
//  Created by Sanjith Udupa on 10/10/21.
//

import Foundation

class StorageManager {
    
    var items: [FoodItem]? = nil
    
    var updatePantryView: MethodHandler = {}
    
    func getItems() -> [FoodItem] {
        if items == nil {
            StorageManager.loadItems()
            PreferencesManager.getInstance().loadItems()
        }
        return items ?? [FoodItem]()
    }
    
    func addItems(newItems: [FoodItem]) {
        StorageManager.getInstance().items?.append(contentsOf: newItems)
    }
    
    func deleteItem(item: FoodItem) {
        if (StorageManager.getInstance().getItems().count > 0) {
            var i = 0
            for iteritem in StorageManager.getInstance().items! {
                if (iteritem.expirationDate == item.expirationDate && iteritem.type == item.type) {
                    items!.remove(at: i)
                    StorageManager.overwriteStoredItems()
                    return
                }
                i += 1
            }
        }
    }
    
    func clearData() {
        StorageManager.getInstance().items = [FoodItem]()
        StorageManager.overwriteStoredItems()
        
        PreferencesManager.getInstance().clearData()
    }
    
    private static var instance: StorageManager? = nil
    
    public static func getInstance() -> StorageManager {
        if (instance == nil) {
            instance = StorageManager()
        }
        return instance!
    }
    
    static let defaults = UserDefaults.standard
    static let encoder = JSONEncoder()
    
    public static func loadItems() {
        if (StorageManager.getInstance().items == nil) {
            let read = readFromStorage()
            StorageManager.getInstance().items = read
        }
    }
    
    public static func readFromStorage() -> [FoodItem] {
        if let data = defaults.data(forKey: "storedFoodItems") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()

                // Decode Items
                let loadedItems = try decoder.decode([FoodItem].self, from: data)
                return loadedItems
            } catch {
                print("Unable to Decode (\(error))")
                return [FoodItem]()
            }
        }
        return [FoodItem]()
    }
    
    public static func overwriteStoredItems() {
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()

            // Encode Items
            let data = try encoder.encode(StorageManager.getInstance().items)

            // Write/Set Data
            defaults.set(data, forKey: "storedFoodItems")

        } catch {
            print("Unable to Encode (\(error))")
        }
    }
}
