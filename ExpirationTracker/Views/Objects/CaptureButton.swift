//
//  CaptureButton.swift
//  ExpirationTracker
//
//  Created by Sanjith Udupa on 8/3/21.
//

import SwiftUI

struct CaptureButton: View {
    @State var pressed: Bool = false
    @State var capturePressed: MethodHandler
    @State var notReady: MethodHandler
    @Binding var enabled: Bool
    @Binding var iconMoving: Bool
    
    @State var size = UIScreen.main.bounds.size.width * (80/375)
    @State var unknown = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .cornerRadius(CGFloat(pressed ? size : size * 0.6))
                    .frame(width: pressed ? CGFloat(size * 2) : CGFloat(size)*1.8, height: pressed ? CGFloat(size * 2) : CGFloat(size)*1.8)
                    .rotationEffect(.init(degrees: enabled ?  0 : 135))
//                    .opacity(ScanManager.getInstance().confident || pressed ? 1 : 0.8)
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: pressed ? CGFloat(size)*0.6 : CGFloat(size)*0.4, x: pressed ? 0 : 5, y: pressed ? 0 : 5)
                    .animation(.spring(response: 1, dampingFraction: 0.8, blendDuration: 0.6))
                Image(systemName: "camera.viewfinder")
                    .resizable()
                    .frame(width: pressed ? CGFloat(size)*0.8 : CGFloat(size), height: pressed ? CGFloat(size)*0.8 : CGFloat(size))
                    .foregroundColor(.white)
                    .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: pressed ? 5 : 15, x: 2.5, y: 2.5)
                    .rotationEffect(.init(degrees: pressed ? 0 : 360))
                    .onTapGesture {
                        if (!iconMoving && !pressed) {
                            if (ScanManager.getInstance().detected != "NONE" && ScanManager.getInstance().detected != "") {
                                pressed = true
                                print(geometry.size.width)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    print(ScanManager.getInstance().detected)
                                    ScanManager.getInstance().selectedName = ScanManager.getInstance().detected

                                    pressed = false
                                    ScanManager.getInstance().capButtonPressed = true
                                    capturePressed()
        //                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        //                                enabled = false
        //                            }
                                }
                            } else {
                                if (ScanManager.getInstance().nextClosest.isEmpty) {
                                    notReady()
                                } else {
                                    unknown = true
                                }
                            }
                        }
                    }
                    .animation(.spring(response: 1, dampingFraction: 0.8, blendDuration: 0.6))
            }
            .position(x: geometry.size.width*(iconMoving ? 0 : 0.5) + (iconMoving ?  CGFloat(size) * 0.75 : 0), y: (geometry.size.height + CGFloat(size)*(enabled ? -1.5 : 2)) + (iconMoving ? CGFloat(size) : 0))
            .scaleEffect(iconMoving ? 0.8 : 1)
            .opacity(enabled ? (iconMoving ? 0.5 : 1) : 0)
            .animation(.spring(response: 2, dampingFraction: 0.8, blendDuration: 0.6))
            .actionSheet(isPresented: $unknown) {
                    ActionSheet(title: Text("Couldn't detect anything"),
                                message: Text("Closest Predictions:"),
                                buttons: getButtons()
                    )
                }
        }
    }
    
    func getButtons() -> [Alert.Button] {
        var arr = [Alert.Button]()
        arr.append(.cancel(Text("Cancel"), action: {
            unknown = false
        }))
        
        var count = 0
        
        for option in ScanManager.getInstance().nextClosest {
            if (count >= 3) {
                break;
            }
            
            arr.append(.default(Text(option), action: {
                unknown = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    print(ScanManager.getInstance().detected)
                    ScanManager.getInstance().selectedName = option

                    ScanManager.getInstance().capButtonPressed = true
                    capturePressed()
                }
            }))
            count += 1
        }
        
        return arr
    }
}

struct CapPreview: View {
    @State var there = false

    var body: some View {
        ZStack {
            Text("Start")
                .onTapGesture {
                    there.toggle()
                }
//            CaptureButton(enabled: $there)
        }
    }
}

//struct CaptureButton_Previews: PreviewProvider {
//    static var previews: some View {
//        CapPreview()
//    }
//}
