//
//  Recipe.swift
//  ExpirationTracker
//
//  Created by Sanjith Udupa on 10/24/21.
//

import Foundation

struct Recipe: Identifiable, Hashable, Codable {
    var id = UUID().uuidString
    
    var title: String
    var domain: String
    var url: String
    var imageAddress: String
    var rating: Int?
    var timeToMake: Int?
    var ingredients: [String]
    var tags: [String]
}
