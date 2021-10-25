//
//  Home.swift
//  ExpirationTracker
//
//  Created by Sanjith Udupa on 10/9/21.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var env : AppEnvironmentData

    var body: some View {
        let home_to_camera = NavigationLink(destination: CameraView().navigationBarHidden(true).navigationBarTitle(""), tag: .Camera, selection: $env.currentPage, label: { EmptyView() })
        let camera_to_list = NavigationLink(destination: ShoppingListView().navigationBarHidden(true).navigationBarTitle(""), tag: .GroceryList, selection: $env.currentPage, label: { EmptyView() })
        return
            NavigationView {
                
                VStack {
                    
                    home_to_camera
                        .frame(width:0, height:0)
                    camera_to_list
                        .frame(width:0, height:0)
                    
                    Home()
                }
            }.navigationBarHidden(true).navigationBarTitle("")
    }
}

struct Home: View {
    @EnvironmentObject var env : AppEnvironmentData

    var body: some View {
        TabView {
            PantryView()
                .tabItem {
                    Image(systemName: "shippingbox")
                    Text("Pantry")
                }
            RecipeSearchView()
                .tabItem {
                    Image(systemName: "doc.text.magnifyingglass")
                    Text("Recipe Search")
                }
            SettingsView()
            .tabItem {
                Image(systemName: "gear")
                Text("Settings")
            }
            
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
