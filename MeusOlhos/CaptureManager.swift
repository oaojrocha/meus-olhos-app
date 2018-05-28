//
//  CaptureManager.swift
//  MeusOlhos
//
//  Created by School Picture Dev on 28/05/18.
//  Copyright © 2018 Eric Brito. All rights reserved.
//

import Foundation
import AVKit

class CaptureManager {
    lazy var captureSession: AVCaptureSession = {
       let cs = AVCaptureSession()
       cs.sessionPreset = .photo
       return cs
    }()
    
    weak var videoBufferDelegate: AVCaptureVideoDataOutputSampleBufferDelegate?
    
    init() {
    }
    
    func startCameraCapture() -> AVCaptureVideoPreviewLayer? {
        if askForPermission() {
            guard let captureDevice = AVCaptureDevice.default(for: .video) else {return nil}
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                captureSession.addInput(input)
            } catch {
                print(error.localizedDescription)
                return nil
            }
            
            captureSession.startRunning()
            
            let videoDataOutput = AVCaptureVideoDataOutput()
            videoDataOutput.setSampleBufferDelegate(videoBufferDelegate, queue: DispatchQueue(label: "cameraQueue"))
            captureSession.addOutput(videoDataOutput)
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            return previewLayer
            
        }
        return nil
    }
    
    
    func askForPermission() -> Bool {
        var hasPermission = true
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                break
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { (success) in
                    hasPermission = success
                }
            case .denied, .restricted:
                hasPermission = false
        }
        
        return hasPermission
    }
}
