//
//  cameraManager.swift
//  ImamApp
//
//  Created by Imam on 15/04/26.
//

import SwiftUI
import AVFoundation

struct cameraManager: View {
    
    private let session = AVCaptureSession()
    
    var body: some View {
        cameraPreview (session: session)
            .ignoresSafeArea()
            .onAppear {
                setupCamera()
            }
            .onDisappear {
                session.stopRunning()
            }
    }
    
    func setupCamera() {
        session.beginConfiguration()
        
        // ambil kamera belakang
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input)
        else { return }
        
        session.addInput(input)
        session.commitConfiguration()
        
        session.startRunning()
    }
}
