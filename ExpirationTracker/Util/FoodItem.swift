//
//  FoodItem.swift
//  ExpirationTracker
//
//  Created by Sanjith Udupa on 10/8/21.
//

import Foundation

struct FoodItem: Identifiable, Hashable, Codable {
    var id = UUID().uuidString
    
    var type: String = ""
    var expirationDate: Date = Date.init()
    
    init(_type: String) {
        self.type = _type;
        self.expirationDate = FoodInfo.getExpirationDate(name: _type);
    }
    
    init(_type: String, _expirationDate: Date) {
        self.type = _type;
        self.expirationDate = _expirationDate;
    }
    
    func timeUntilExpiration() -> Double {
        return Date().distance(to: expirationDate)
    }
    
    public func getFoodState() -> FoodState {
        return (self.timeUntilExpiration() < 0.25) ? .EXPIRED : (self.timeUntilExpiration() < Double(PreferencesManager.getInstance().warning_interval * 24 * 60 * 60) ? .NEARLY_EXPIRED : .OK)
    }
}
