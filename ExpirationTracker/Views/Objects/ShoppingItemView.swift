//
//  ShoppingItemView.swift
//  ExpirationTracker
//
//  Created by Sanjith Udupa on 10/10/21.
//

import Foundation
import SwiftUI

struct ShoppingItemView: View {
    @State var item: FoodItem
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                Image(item.type.lowercased())
                    .resizable()
                    .frame(width: geometry.size.height * 0.85, height: geometry.size.height * 0.85, alignment: .center)
                    .shadow(radius: 12, x: 6, y: 6).padding(.top, 5)
                VStack {
                    Text(item.type)
                        .font(.init(.largeTitle))
                        .fontWeight(.heavy)
                        .frame(width: geometry.size.width, alignment: .topLeading)
                        .shadow(radius: 10, x: 5, y: 6)

                    Text(FoodInfo.formatFoodLabel(date: item.expirationDate) + " until expiry")
                        .foregroundColor(.gray)
                        .frame(width: geometry.size.width, alignment: .topLeading)
                }
                
            }
        }
    }
}
