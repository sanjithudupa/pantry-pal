//
//  App.swift
//  ExpirationTracker
//
//  Created by Sanjith Udupa on 7/30/21.
//

import SwiftUI

enum AppPage {
    case Home
    case Camera
    case GroceryList
}

final class AppEnvironmentData: ObservableObject {
    @Published var currentPage : AppPage? = .Home
}

#if DEBUG
struct App_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(AppEnvironmentData())
    }
}
#endif
