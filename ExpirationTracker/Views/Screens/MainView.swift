//
//  MainView.swift
//  ExpirationTracker
//
//  Created by Sanjith Udupa on 7/30/21.
//

import SwiftUI

typealias MethodHandler = () -> Void
    
struct MainView: View {
    @State var detectedGrocery: String = ""
    @State var showing: Bool = false
    @State var finishedAnimation: Bool = false
    @State var capButton: Bool = true
    @State var unsure: Bool = false;
    
    func shopActionF() {}
    
    @State var shopAction = shopActionF
    
    func foundGrocery() {
        detectedGrocery = ScanManager.getInstance().detected
    }
    
    func onCapturePressed() {
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
            
            AnimatedIcon(showing: $showing, finished: $finishedAnimation, moving: false)
            
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
            
//            if (ScanManager.getInstance().iterSinceLast > 2) {
//                Text("BLANK")
//                    .opacity(0)
//                    .onAppear {
//                        capButton = true
//                    }
//            }
            
            FlashButton()
            CaptureButton(capturePressed: onCapturePressed, notReady: notReady, enabled: $capButton, iconMoving: $showing)
            
//            ShoppingBasket()
            
            Group {
                VisualEffectView(effect: UIBlurEffect(style: .dark))
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    LoadingView(isAnimating: $unsure, style: .large)
                        .foregroundColor(.white)
                    Text("Scanner not yet initialized, please wait")
                }
            }.opacity(unsure ? 1 : 0).animation(.spring())
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
//}
