//
//  CameraViewController.swift
//  CollectionView App
//
//  Created by Yerkezhan Zheneessova on 25.01.2024.
//

import Foundation
import AVFoundation
import UIKit

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate{
    
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCapturePhotoOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("in camera view did load")

        setupCamera()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("in camera will appear")

    }
    
    
    
    func setupCamera(){
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .photo
        
        guard let backCamera = AVCaptureDevice.default(for: .video), let input = try? AVCaptureDeviceInput(device: backCamera) else {
            return
    }
        stillImageOutput = AVCapturePhotoOutput()

        if let captureSession = captureSession,
                    captureSession.canAddInput(input),
                    captureSession.canAddOutput(stillImageOutput!) {
                    
                    captureSession.addInput(input)
                    captureSession.addOutput(stillImageOutput!)
                    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                    previewLayer?.videoGravity = .resizeAspectFill
                    previewLayer?.connection?.videoOrientation = .portrait
                    view.layer.addSublayer(previewLayer!)
                    captureSession.startRunning()
                }
    }
    
}


