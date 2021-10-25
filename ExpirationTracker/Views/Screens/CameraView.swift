//
//  MainView.swift
//  ExpirationTracker
//
//  Created by Sanjith Udupa on 7/30/21.
// all icons by FreePik, Icongeek26, monkik, prettyicons

import SwiftUI

typealias MethodHandler = () -> Void
    
struct CameraView: View {
    @EnvironmentObject var env : AppEnvironmentData
    
    @State var detectedGrocery: String = ""
    @State var showing: Bool = false
    @State var finishedAnimation: Bool = false
    @State var capButton: Bool = true
    @State var unsure: Bool = false;
    @State var animMoving = false
    @State var lastPress: Int = 0;
    
    func foundGrocery() {
        detectedGrocery = ScanManager.getInstance().detected
    }
    
    func getCurrentTimeInMilliseconds() -> Int {
         return Int(Date().timeIntervalSince1970 * 1000)
    }
    
    func onCapturePressed() {
        lastPress = getCurrentTimeInMilliseconds()
        if (showing && !finishedAnimation) {
            showing = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                showing = true
            }
        } else {
            showing = true
        }
    }
    
    func notReady() {
        unsure = true;
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            unsure = false
        }
    }
    
    var body: some View {
        ZStack {
            CameraRepresentable(foundGrocery: foundGrocery)
//            Text(detectedGrocery)
//                .padding()
//            Text(String(ScanManager.getInstance().iterSinceLast))
//                .offset(y: 200)
//            Text(String(finishedAnimation))
//                .offset(y: 200)
//            Text(String(ScanManager.getInstance().confident))
//                .offset(y: 210)
//            Text(String(ScanManager.getInstance().confidenceLevel))
//                .offset(y: 220)
            
            AnimatedIcon(showing: $showing, finished: $finishedAnimation, moving: $animMoving)
//            Text(String(lastPress - getCurrentTimeInMilliseconds()))
            
//            if (/*(ScanManager.getInstance().confident && !capButton) ||*/ ScanManager.getInstance().capButtonPressed) {
//                Color.green.opacity(0.5)
//                    .onAppear {
////                        moved to oncapturepressed
//                        if (showing && !finishedAnimation) {
//                            showing = false
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                                showing = true
//                            }
//                        } else {
//                            showing = true
//                        }
//                    }
//            }
            
            if (finishedAnimation) {
                Text("BLANK")
                    .opacity(0)
                    .onAppear {
                        showing = false
                        ScanManager.getInstance().capButtonPressed = false
                    }
            }
            
            if (animMoving) {
                Text("")
                    .opacity(0)
                    .onAppear {
                        if (ScanManager.getInstance().selectedName != "NONE") {
                            ScanManager.getInstance().registerItem()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            ScanManager.getInstance().shop_action()
                        }
                    }
            }
            
//            if (ScanManager.getInstance().iterSinceLast > 2) {
//                Text("BLANK")
//                    .opacity(0)
//                    .onAppear {
//                        capButton = true
//                    }
//            }
            
            FlashButton()
            CaptureButton(capturePressed: onCapturePressed, notReady: notReady, enabled: $capButton, iconMoving: $showing)
            
            
            Text("Double tap the basket to when you have finished scanning")
                .font(.init(.headline))
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .shadow(radius: 5)
                .opacity((getCurrentTimeInMilliseconds() - lastPress > 8000 && getCurrentTimeInMilliseconds() - lastPress < 16000 && lastPress != 0) ? 1 : 0)
                .animation(.spring())
            
            ShoppingBasket()
                .onTapGesture(count: 2, perform: {
                    self.env.currentPage = .GroceryList
                })
            
            Group {
                VisualEffectView(effect: UIBlurEffect(style: .dark))
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    LoadingView(isAnimating: $unsure, style: .large)
                        .foregroundColor(.white)
                    Text("Scanner not yet initialized, please wait")
                }
            }.opacity(unsure ? 1 : 0).animation(.spring())
        }.statusBar(hidden: true)
        .onAppear {
            lastPress = getCurrentTimeInMilliseconds()
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
//}
