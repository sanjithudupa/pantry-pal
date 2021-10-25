//
//  ShoppingBasket.swift
//  ExpirationTracker
//
//  Created by Sanjith Udupa on 8/20/21.
//

import SwiftUI

struct ShoppingBasket: View {
    var size = CGFloat(85.0)
    
    @State var animating = false
    @State var needed = false
    @State var scale     = -1.0
    @State var plusIcon = true
//    @Binding var shoppingAction: MethodHandler
    
    func shopAction() {
            if (!animating) {
                animating = true
                plusIcon = false
            }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("basket")
                    .resizable()
                    .frame(width: size, height: size, alignment: .center)
                    .rotationEffect(.init(degrees: animating ? (30 * scale) : 0))
                    .scaleEffect(animating ? 1.1 : 1)
                    .offset(x: geometry.size.width - size * (1.25), y: geometry.size.height - size * 1.25)
                    .animation(.spring(response: 1, dampingFraction: 0.4, blendDuration: 0.5))
                    .shadow(radius: 15)
                
                ZStack {
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: size/4, height: size/4, alignment: .center)
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .foregroundColor(.green)
                        .frame(width: size/4, height: size/4, alignment: .center)
                }
                .rotationEffect(.init(degrees: plusIcon ? 0 : -180))
                .shadow(radius: 10)
                .scaleEffect(plusIcon ? 1 : 1.25)
                .opacity(plusIcon ? 0 : 1)
                .offset(x: geometry.size.width - size * 0.70  - (!plusIcon ? size * 0.15 : 0), y: (geometry.size.height - size * 1.5) - (!plusIcon ? size * 0.3 : 0))
                .animation(.spring(response: 1, dampingFraction: 0.6, blendDuration: 0.5))
                
                if(animating) {
                    Text("BLANK")
                        .opacity(0)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                animating = false
                                scale = (Double.random(in: -1.0 ..< 1.0))
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        plusIcon = true
                                }
                            }
                        }
                }
            }
        }
        .onAppear {
            ScanManager.getInstance().shop_action = shopAction;
        }
    }
}

struct ShoppingBasket_Previews: PreviewProvider {
    static var previews: some View {
//        ShoppingBasket()
//            .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
        Text("Placeholder")
    }
}
