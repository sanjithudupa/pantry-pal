//
//  RecipeView.swift
//  ExpirationTracker
//
//  Created by Sanjith Udupa on 10/24/21.
//

import SwiftUI

struct RecipeView: View {
    var recipe: Recipe
    var body: some View {
        ZStack {
            Color.white.opacity(0.5)
            
            RemoteImage(url: recipe.imageAddress)
                .aspectRatio(contentMode: .fill)
            VStack(alignment: .center, spacing: 0){
                HStack() {
                    VStack(alignment: .leading) {
                        Text(recipe.title)
                            .font(.headline)
                        Text(recipe.domain)
                            .font(.caption)
                    }.shadow(color: .blue.opacity(0.3), radius: 25, x: 2.5, y: 2.5)
                    Spacer()
                }
                .padding(7.5)
                .frame(width: UIScreen.main.bounds.width * 0.85)
                .background(Color.white)
                .shadow(radius: 20)
                Spacer()
            }
            
            Button(action: {
                if let url = URL(string: recipe.url) {
                    UIApplication.shared.open(url)
                }
            }) {
                Image(systemName: "safari")
                    .foregroundColor(.blue)
            }
            .offset(x: UIScreen.main.bounds.width * 0.85 * 0.5 - 20, y: -UIScreen.main.bounds.width * 0.85 * 0.3 + 20)
        }.frame(width: UIScreen.main.bounds.width  * 0.85, height: UIScreen.main.bounds.width  * 0.85 * 0.6, alignment: .center)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.3), radius: 25, x: 2.5, y: 2.5)
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 30) {
                RecipeView(recipe: Recipe(title: "Homemade Tomato Paste", domain: "brooklynfarmgirl.com", url: "https://brooklynfarmgirl.com/homemade-tomato-paste/", imageAddress: "https://i2.supercook.com/d/8/d/d/d8ddc902bec93f40f31e56ffd338f661-0.jpg", rating: nil, timeToMake: nil, ingredients: ["tomato", "garlic"], tags: []))
            }.padding().frame(width: UIScreen.main.bounds.width)
        }
    }
}
