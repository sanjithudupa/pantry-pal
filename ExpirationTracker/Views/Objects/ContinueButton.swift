//
//  ContinueButton.swift
//  ExpirationTracker
//
//  Created by Sanjith Udupa on 10/10/21.
//

import Foundation
import SwiftUI

struct ContinueButton: View {
    @State var contFunc: MethodHandler
    
    var body: some View {
        GeometryReader { geometry in
            Button(action: {
                contFunc()
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: geometry.size.width * 0.75 * 0.25 * 0.25)
                        .foregroundColor(.blue)
                        .shadow(radius: 20, x: 15, y: 5)
                    Text("Add to Pantry")
                        .font(.init(.largeTitle))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                }.frame(width: geometry.size.width * 0.75, height: geometry.size.width * 0.75 * 0.25)
            }.offset(x: geometry.size.width * 0.125, y: geometry.size.height * 0.8)
        }
    }
}
