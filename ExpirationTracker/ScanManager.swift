//
//  ScanManager.swift
//  ExpirationTracker
//
//  Created by Sanjith Udupa on 7/31/21.
//

import Foundation

class ScanManager {
    var scanState = ScanningState.OFF
    var detected = ""
    var selectedName = ""
    var confidenceLevel: Float = 0.0
    var confident = false
    var nextClosest: [String] = [String]()
    var iterSinceLast: Int = 0
    var iterSinceLastVisible: Int = 0
    var toggleFlashlight: () -> Void = { }
    var capButtonPressed: Bool = false
    
    private static var instance: ScanManager? = nil
    
    public static func getInstance() -> ScanManager {
        if (instance == nil) {
            instance = ScanManager()
        }
        return instance!
    }
    
    public static var CONFIDENCE_THRESHOLD = Float(0.675)
}

enum ScanningState {
    case OFF
    case SCANNING
    case DETECTED
}
