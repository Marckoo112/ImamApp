//
//  CameraPreviewView.swift
//  PoonaApp
//
//  Created by Sande Effendi on 16/04/26.
//

import AVFoundation
import SwiftUI

struct CameraPreviewView: UIViewControllerRepresentable {
    let session: AVCaptureSession

    func makeUIViewController(context: Context) -> CameraPreviewViewController {
        let controller = CameraPreviewViewController()
        controller.previewLayer.session = session
        controller.previewLayer.videoGravity = .resizeAspectFill
        return controller
    }

    func updateUIViewController(_ uiViewController: CameraPreviewViewController, context: Context) {
        uiViewController.previewLayer.session = session
    }
}

class CameraPreviewViewController: UIViewController {
    let previewLayer = AVCaptureVideoPreviewLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.addSublayer(previewLayer)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
    }
}
