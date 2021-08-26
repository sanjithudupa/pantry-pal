//
//  FlashButton.swift
//  ExpirationTracker
//
//  Created by Sanjith Udupa on 8/3/21.
//

import SwiftUI

struct FlashButton: View {
    @State var enabled = false
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    Image(systemName: "bolt.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.blue)
                        .rotationEffect(.init(degrees: enabled ? 0 : 360))
                        .animation(.spring())
                        .onTapGesture {
                            enabled.toggle()
                            ScanManager.getInstance().toggleFlashlight()
                        }
                    
                    Rectangle()
                        .fill(Color.blue)
                        .border(Color.blue)
                        .cornerRadius(5)
                        .frame(width: 5, height: enabled ? 40 : 0)
                        .rotationEffect(.init(degrees: enabled ? -45 : 0))
                        .animation(.spring())
                }
                ZStack {
                    Text("Disable")
                        .fontWeight(.heavy)
                        .opacity(enabled ? 1 : 0)
                        .foregroundColor(.white)
                        .animation(.spring())
                    Text("Enable")
                        .fontWeight(.heavy)
                        .opacity(enabled ? 0 : 1)
                        .foregroundColor(.white)
                        .animation(.spring())
                }
            }.position(x: geometry.size.width - 43.75, y: 50)
        }
    }
}

//struct FlashButton_Previews: PreviewProvider {
//    static var previews: some View {
//        ZStack {
//            Color.black
//            FlashButton()
//        }
//    }
//}
