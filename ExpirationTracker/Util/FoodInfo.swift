//
//  FoodInfo.swift
//  ExpirationTracker
//
//  Created by Sanjith Udupa on 10/8/21.
//

import Foundation

class FoodInfo {
    
    public static var foodItems = [
        "Apple",
        "Apple Juice",
        "Asparagus",
        "Aubergine",
        "Avocado",
        "Banana",
        "Beetroot",
        "Cabbage",
        "Cantaloupe",
        "Carrots",
        "Cucumber",
        "Garlic",
        "Ginger",
        "Grapefruit",
        "Grapefruit Juice",
        "Honeydew",
        "Kiwi",
        "Leek",
        "Lemon",
        "Lime",
        "Mango",
        "Milk",
        "Mushroom",
        "Onion",
        "Orange",
        "Orange Juice",
        "Papaya",
        "Passion Fruit",
        "Peach",
        "Pear",
        "Pepper",
        "Pineapple",
        "Plum",
        "Pomegranate",
        "Potato",
        "Sour Cream",
        "Soy Milk",
        "Tomato",
        "Watermelon",
        "Yogurt",
        "Zucchini"
    ]
    
    // all in DAYS
    private static var expirationTimes = [
        "Apple": 2 * 7,
        "Apple Juice": 8,
        "Asparagus": 4,
        "Aubergine": 6,
        "Avocado": 3,
        "Banana": 6,
        "Beetroot": 2 * 7,
        "Cabbage": Int(1.5 * 7),
        "Cantaloupe": 9,
        "Carrots": 3 * 7,
        "Cucumber": 2 * 7,
        "Garlic": 4 * 7,
        "Ginger": Int(2.5 * 7),
        "Grapefruit": Int(3.5 * 7),
        "Grapefruit Juice": 8,
        "Honeydew": 8,
        "Kiwi": 6,
        "Leek": Int(1.5 * 7),
        "Lemon": Int(1.5 * 7),
        "Lime": 3 * 7,
        "Mango": 7,
        "Milk": 10,
        "Mushroom": 8,
        "Onion": 12,
        "Orange": 2 * 7,
        "Orange Juice": 8,
        "Papaya": 6,
        "Passion Fruit": Int(1.5 * 7),
        "Peach": 4,
        "Pear": 5,
        "Pepper": Int(1.5 * 7),
        "Pineapple": 5,
        "Plum": 4,
        "Pomegranate": 4 * 7,
        "Potato": 5 * 7,
        "Sour Cream": Int(2.5 * 7),
        "Soy Milk": 8,
        "Tomato": 6,
        "Watermelon": 8,
        "Yogurt": 7 * 2,
        "Zucchini": 7
        
    ]
    
    public static func getExpirationDate(name: String) -> Date {
        let days = expirationTimes[name]
        
        if (days == nil) {
            return Date()
        }
        
        let adjustedDate: Date = Calendar.current.date(byAdding: .day, value: days!, to: Date())!
        
        return Calendar(identifier: .gregorian).startOfDay(for: adjustedDate);
    }
    
    public static func formatFoodLabel(date: Date) -> String {
        let dist: TimeInterval = Calendar.current.date(byAdding: .day, value: -1, to: Date())!.distance(to: date)
        
        print(date.description)
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day]
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 1

        return formatter.string(from: dist)!
    }
    
    public static func sortFoodItems(foodItems: [FoodItem]) -> [String: [String: [FoodItem]]] {
        var result: [String: [String: [FoodItem]]] = [:]
        
        for category in PreferencesManager.getInstance().pantry_categories.keys.sorted() {
            var itemsInCategory: [String: [FoodItem]] = [:]
            
            for foodItem in foodItems {
                if (PreferencesManager.getInstance().pantry_categories[category.description]!.contains(foodItem.type)) {
                    if (itemsInCategory[foodItem.type] != nil) {
                        itemsInCategory[foodItem.type]!.append(foodItem)
                    } else {
                        itemsInCategory[foodItem.type] = [foodItem]
                    }
                }
            }
            
//            for item in itemsInCategory {
//                item.sort {
//                    $0.timeUntilExpiration() < $1.timeUntilExpiration()
//                }
//            }
            
            result[category] = itemsInCategory
        }
        
        return result
    }
    
    public static func getStatusOfFoodItems(foodItems: [FoodItem]) -> FoodState {
        var status: FoodState = .OK
        
        for foodItem in foodItems {
            let state = foodItem.getFoodState()
            if (status == .OK || status == .NEARLY_EXPIRED) {
                status = state
            }
        }
        
        return status
    }
}
