//
//  AnimatedIcon.swift
//  ExpirationTracker
//
//  Created by Sanjith Udupa on 8/3/21.
//

import SwiftUI

struct AnimatedIcon: View {
    @Binding var showing: Bool
    @Binding var finished: Bool
    @State var current: String = "Milk"
    @Binding var moving: Bool
    @State var incorrect = false
    @State var confirmedIncorrect = false
    @State var fadeOut = false
    @State var original = ""
    
    var imageSize = 150.0;
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Image(ScanManager.getInstance().selectedName.lowercased()).resizable().frame(width: moving ? CGFloat(0.5 * imageSize) : showing ? CGFloat(imageSize) : 0, height: moving ? CGFloat(0.5 * imageSize) : showing ?  CGFloat(imageSize) : 0).position(x: moving ? geometry.size.width + CGFloat(imageSize/2) : geometry.size.width/2, y: moving ? geometry.size.height : geometry.size.height/2)
                    .opacity(fadeOut ? 0 : (showing && !moving ? 1 : 0))
                    .rotationEffect(showing && !moving ? .zero : moving ?.init(degrees: 20) : .init(degrees: -90), anchor: UnitPoint(x: 0.5, y: 0.5 + ((CGFloat(imageSize) * 0.15625)/geometry.size.width)))
                    .animation(.spring(response: moving ? 2  : 1, dampingFraction: 0.5, blendDuration: 0.1))
                Button(action: {incorrect = true}, label: {
                    Text("Not " + (original != "" ? original : ScanManager.getInstance().selectedName) + "?")
                        .padding(5)
                        .foregroundColor(.white)
                        .background(Color.blue.opacity(0.7).cornerRadius(3.0))
                })
                .opacity(showing && !moving && !confirmedIncorrect ? 1 : 0)
                .offset(x: 0, y: CGFloat(showing && !moving ? -imageSize - 20 : -(imageSize/2)))
                .animation(.spring(response: confirmedIncorrect ? 1 : 2, dampingFraction: 0.8, blendDuration: 0.2))
                .actionSheet(isPresented: $incorrect) {
                        ActionSheet(title: Text("Choose another Item"),
                                    message: Text("Closest Predictions:"),
                                    buttons: getButtons()
                        )
                    }
    //            .alert(isPresented: $incorrect, content: {
    //                Alert(title: Text("Options"))
                if (showing) {
                    Text("BLANK")
                        .opacity(0)
                        .onAppear {
                            finished = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                                    if (!incorrect) {
                                        moving = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            finished = true
                                        }
                                    }
                                }
                        }
                        .onDisappear {
                            moving = false
                        }
                }
            }
        }
    }
    
    func getButtons() -> [Alert.Button] {
        var arr = [Alert.Button]()
//        arr.append(.cancel())
        
        var count = 0
        
        for option in ScanManager.getInstance().nextClosest {
            if (count >= 3) {
                break;
            }
            
            arr.append(.default(Text(option), action: {
                confirmedIncorrect = true
                fadeOut = true
                original = ScanManager.getInstance().selectedName
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    ScanManager.getInstance().selectedName = option
                    fadeOut = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                        incorrect = false
                        moving = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            showing = false
                            confirmedIncorrect = false
                            original = ""
                        }
                    }
                }
            }))
            count += 1
        }
        
        arr.append(.cancel(Text("Cancel"), action: {
            incorrect = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    moving = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        showing = false
                    }
            }
        }))
        
        return arr
    }
}


struct AnimPreview: View {
    @State var showing: Bool = false
    @State var finished = false
    
    var body: some View {
        ZStack {
//            if (showing){
            AnimatedIcon(showing: $showing, finished: $finished, moving: .constant(false))
//            }
            Button("Start") {
                showing.toggle()
            }.offset(x: 0, y: 200)
        }
    }
}

//struct AnimatedIcon_Previews: PreviewProvider {
//    static var previews: some View {
//        AnimPreview()
//    }
//}
