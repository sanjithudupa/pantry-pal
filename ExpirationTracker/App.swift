//
//  App.swift
//  ExpirationTracker
//
//  Created by Sanjith Udupa on 7/30/21.
//

import SwiftUI

struct App: View {
    var body: some View {
        MainView()
            .statusBar(hidden: true)
    }
}

struct App_Previews: PreviewProvider {
    static var previews: some View {
        App()
    }
}
