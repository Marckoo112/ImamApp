import SwiftUI
import AVFoundation

// MARK: - Camera Preview (UIViewRepresentable)
// Wraps AVCaptureVideoPreviewLayer for use in SwiftUI.

struct cameraPreview: UIViewRepresentable {

    let session: AVCaptureSession

    func makeUIView(context: Context) -> PreviewUIView {
        let view = PreviewUIView()
        view.previewLayer.session = session
        view.previewLayer.videoGravity = .resizeAspectFill
        return view
    }

    func updateUIView(_ uiView: PreviewUIView, context: Context) {
        // Session is already bound
    }

    // Custom UIView subclass so the preview layer resizes correctly.
    class PreviewUIView: UIView {

        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }

        var previewLayer: AVCaptureVideoPreviewLayer {
            layer as! AVCaptureVideoPreviewLayer
        }
    }
}


