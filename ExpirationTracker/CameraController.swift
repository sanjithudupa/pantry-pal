//
//  CameraController.swift
//  ExpirationTracker
//
//  Created by Sanjith Udupa on 7/31/21.
//

import AVFoundation
import UIKit
import Vision

class CameraController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    var delegate: GroceryScannerDelegate?
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    private let videoDataOutput = AVCaptureVideoDataOutput()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        func toggleFlash() {
            guard videoCaptureDevice.hasTorch else { return }

            do {
                try videoCaptureDevice.lockForConfiguration()

                if (videoCaptureDevice.torchMode == AVCaptureDevice.TorchMode.on) {
                    videoCaptureDevice.torchMode = AVCaptureDevice.TorchMode.off
                } else {
                    do {
                        try videoCaptureDevice.setTorchModeOn(level: 1.0)
                    } catch {
                        print(error)
                    }
                }

                videoCaptureDevice.unlockForConfiguration()
            } catch {
                print(error)
            }
        }
        
        ScanManager.getInstance().toggleFlashlight = toggleFlash
        
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch { return }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        }
        
        self.videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
        
        self.videoDataOutput.alwaysDiscardsLateVideoFrames = true
        self.videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera_frame_processing_queue"))
        self.captureSession.addOutput(self.videoDataOutput)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = self.view.frame
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
        
        ScanManager.getInstance().scanState = ScanningState.SCANNING
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera_frame_processing_queue"))
        
        if captureSession?.isRunning == false {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if captureSession?.isRunning == true {
            captureSession.stopRunning()
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    lazy var classificationRequest: VNCoreMLRequest = {
            do {
                let model = try VNCoreMLModel(for: GroceryClassifierV3().model)
                
                let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                    self?.processClassifications(for: request, error: error)
                })
                request.imageCropAndScaleOption = .centerCrop
                return request
            } catch {
                fatalError("Failed to load Vision ML model: \(error)")
            }
        }()
        
    func captureOutput(
            _ output: AVCaptureOutput,
            didOutput sampleBuffer: CMSampleBuffer,
            from connection: AVCaptureConnection) {
            
            guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                debugPrint("unable to get image from sample buffer")
                return
            }
            
            self.updateClassifications(in: frame)
        }
        

    func updateClassifications(in image: CVPixelBuffer) {

            DispatchQueue.global(qos: .userInitiated).async {
                let handler = VNImageRequestHandler(cvPixelBuffer: image, orientation: .right, options: [:])
                do {
                    try handler.perform([self.classificationRequest])
                } catch {
                    print("Failed to perform classification.\n\(error.localizedDescription)")
                }
            }
        }
        
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                return
            }
            let classifications = results as! [VNClassificationObservation]

            if !classifications.isEmpty && classifications.first!.confidence > 0.5 {
                if classifications.first!.confidence > 0.5 {
                    let identifier = classifications.first?.identifier ?? ""
                    
                    if (identifier != "" && identifier != "Sour Cream") {
                        
                        var SecondaryOptions = [String]()
                        var fakeClassifications = classifications
                        fakeClassifications.removeFirst()
                        for option in fakeClassifications {
                            SecondaryOptions.append(option.identifier)
                        }

                        ScanManager.getInstance().nextClosest = SecondaryOptions
                        
                        if (identifier != ScanManager.getInstance().detected) {
                            ScanManager.getInstance().confident = false;
                        }
                        
                        ScanManager.getInstance().detected = identifier
                        ScanManager.getInstance().confidenceLevel = classifications.first!.confidence
                        
                        if (!ScanManager.getInstance().confident) {
                            ScanManager.getInstance().confident = ScanManager.getInstance().confidenceLevel > ScanManager.CONFIDENCE_THRESHOLD
                            ScanManager.getInstance().iterSinceLast += 1
                        } else {
                            ScanManager.getInstance().iterSinceLast = 0
                        }
                        
                        ScanManager.getInstance().scanState = ScanningState.DETECTED
                        
                        self.delegate?.detectedGrocery()
                    }
                } else {
                    ScanManager.getInstance().scanState = ScanningState.SCANNING
                    ScanManager.getInstance().detected = "NONE"
                }
            } else {
                ScanManager.getInstance().scanState = ScanningState.SCANNING
                ScanManager.getInstance().detected = "NONE"
            }
        }
    }
}

protocol GroceryScannerDelegate {
    func detectedGrocery()
}
