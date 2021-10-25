//
//  PreferencesManager.swift
//  ExpirationTracker
//
//  Created by Sanjith Udupa on 10/12/21.
//

import Foundation

class PreferencesManager {
    
    var pantry_categories: [String: [String]] = [
        "Dairy": [
            "Milk",
//            "Sour Cream",
//            "Soy Milk",
            "Yogurt",
        ],
        "Vegetables": [
            "Zucchini",
            "Pepper",
            "Leek",
            "Mushroom",
            "Asparagus",
//            "Pomegranate",
            "Aubergine",
            "Avocado",
            "Beetroot",
            "Cabbage",
//            "Carrots",
            "Cucumber",
        ],
        "Juices": [
            "Apple Juice",
            "Grapefruit Juice",
            "Orange Juice"
        ],
        "Fruits": [
            "Apple",
            "Orange",
            "Watermelon",
            "Banana",
            "Peach",
            "Pear",
//            "Papaya",
//            "Passion Fruit",
            "Tomato",
            "Pineapple",
//            "Plum",
            "Honeydew",
            "Grapefruit",
            "Lemon",
            "Lime",
            "Mango",
            "Kiwi",
            "Cantaloupe",
        ],
        "Misc": [
            "Garlic",
//            "Ginger",
            "Potato",
            "Onion",
        ],
    ]
    
    var warning_interval = 3
    var recipe_number = 20
    
    func loadItems() {
        if (isKeyPresentInUserDefaults(key: "warning_interval")) {
            save()
        } else {
            warning_interval = UserDefaults.standard.integer(forKey: "warning_interval")
            recipe_number = UserDefaults.standard.integer(forKey: "recipe_number")
        }

    }
    
    func save() {
        UserDefaults.standard.set(warning_interval, forKey: "warning_interval")
        UserDefaults.standard.set(recipe_number, forKey: "recipe_number")
    }
    
    func clearData() {
        warning_interval = 3
        recipe_number = 20
        
        save();
    }
    
    var onChange: MethodHandler = {}
    
    private static var instance: PreferencesManager? = nil
    
    public static func getInstance() -> PreferencesManager {
        if (instance == nil) {
            instance = PreferencesManager()
        }
        return instance!
    }
}

func isKeyPresentInUserDefaults(key: String) -> Bool {
    return UserDefaults.standard.object(forKey: key) != nil
}
