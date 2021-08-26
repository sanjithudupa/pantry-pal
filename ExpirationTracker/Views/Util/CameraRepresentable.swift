//
//  CameraRepresentable.swift
//  ExpirationTracker
//
//  Created by Sanjith Udupa on 8/1/21.
//

import Foundation
import SwiftUI

struct CameraRepresentable: UIViewControllerRepresentable {
    
    @State var foundGrocery: MethodHandler
    
    func makeUIViewController(context: Context) -> CameraController {
        let controller = CameraController()
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ cameraViewController: CameraController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(foundGrocery: $foundGrocery)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, GroceryScannerDelegate {
        @Binding var foundGrocery: () -> Void
        
        init(foundGrocery: Binding<() -> Void>) {
            _foundGrocery = foundGrocery
        }
        
        func detectedGrocery() {
            foundGrocery()
        }
    }
}
