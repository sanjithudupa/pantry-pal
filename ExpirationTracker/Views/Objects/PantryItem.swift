//
//  PantryItem.swift
//  ExpirationTracker
//
//  Created by Sanjith Udupa on 10/12/21.
//

import Foundation
import SwiftUI

struct PantryItem: View {
    @State var items: [FoodItem]
    @State var state: FoodState = .OK
    
    var size = CGFloat(100.0)
    
    var body: some View {
        ZStack {
            Image(items[0].type.lowercased())
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
            if (state != .OK) {
                ZStack {
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: size/4, height: size/4, alignment: .center)
                    Image(systemName: "exclamationmark.circle.fill")
                        .resizable()
                        .foregroundColor((state == .NEARLY_EXPIRED ? Color.yellow : Color.red))
                        .frame(width: size/4, height: size/4, alignment: .center)
                }
                .shadow(color: (state == .NEARLY_EXPIRED ? Color.yellow : Color.red).opacity(0.4), radius: 10)
                .scaleEffect(1.25)
                .opacity(1)
                .offset(x: size/2, y: size/2.5)
                .animation(.spring(response: 1, dampingFraction: 0.6, blendDuration: 0.5))
            }
        }.onAppear {
            state = FoodInfo.getStatusOfFoodItems(foodItems: items)
        }
    }
}
