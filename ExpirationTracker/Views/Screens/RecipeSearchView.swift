//
//  RecipeSearchView.swift
//  ExpirationTracker
//
//  Created by Sanjith Udupa on 10/14/21.
//

import Foundation
import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { selection in
                self.wrappedValue = selection
                handler(selection)
        })
    }
}

struct RecipeSearchView: View {
    @State var recipeList: [Recipe] = [Recipe]()
    @State var onZeroIngredients: MethodHandler = {}
    
    var body: some View {
        ZStack {
            
            VStack {
                if (recipeList.count > 0) {
                    Spacer()
                    Spacer()
                }
                RecipeList(recipes: $recipeList, onZeroIngredients: $onZeroIngredients)
            }
            VStack {
                Text("Recipe Search")
                    .font(.title)
                    .bold()
                    .shadow(radius: 20)
                    .frame(width: UIScreen.main.bounds.width, height: 30)
                    .background(Color.white)
                HStack(spacing: 0) {
                    Text("Powered by ")
                    Button(action: {
                        if let url = URL(string: "https://www.supercook.com") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text("SuperCook")
                            .underline()
                    }.foregroundColor(.black)
                }
                .font(.caption)
                .opacity(recipeList.count > 0 ? 0 : 1)
                .animation(.spring())
                Spacer()
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        searchForRecipes()
                    }) {
                        Image(systemName: "magnifyingglass.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }.padding(.trailing)
                    .offset(y: 3)
                }
                Spacer()
            }
            
            
        }.navigationBarHidden(true).navigationBarTitle("")
        .onAppear {
            searchForRecipes()
        }
        
        
    }
    
    func searchForRecipes() {
        var ingredients = Set<String>()
        
        for item in StorageManager.getInstance().getItems() {
            ingredients.insert(item.type.lowercased())
        }
        
        if (ingredients.count > 0) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                RecipeManager.getInstance().searchForRecipes(ingredients: Array(ingredients), completion: { recipes in
                    recipeList = [Recipe]()
                        var count = 0
                        for recipe in recipes {
                            if (count < min(PreferencesManager.getInstance().recipe_number, recipes.count - 1)) {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25 * Double(count)) {
                                    recipeList.append(recipe)
                                }
                            }
                            count += 1
                        }
                        recipeList = recipes
                    })
            }
        } else {
            onZeroIngredients()
        }
    }
}

struct RecipeList: View {
    @Binding var recipes: [Recipe]
    @Binding var onZeroIngredients: MethodHandler
    @State var isZero = false
    
    var body: some View {
        if (recipes.count == 0) {
            VStack {
                Text(isZero ? "You don't have any food items saved. Scan some first." : "Searching for recipes with your ingredients...")
                if (!isZero) {
                    LoadingView(isAnimating: .constant(true), style: .medium)
                }
            }.onAppear {
                isZero = false
                onZeroIngredients = onZero
            }
        } else {
            ScrollView {
                VStack(spacing: 30) {
                    Spacer()
                    ForEach(recipes, id: \.self) {
                        recipe in
                        RecipeView(recipe: recipe)
                            .transition(AnyTransition.scale)
                    }
                }.padding().frame(width: UIScreen.main.bounds.width)
            }
        }
    }
    
    func onZero() {
        isZero = true;
    }
}

struct RecipeViewPreview: PreviewProvider {
    static var previews: some View {
        RecipeSearchView()
    }
}

