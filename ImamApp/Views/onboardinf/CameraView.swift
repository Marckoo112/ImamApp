import AVFoundation
import Combine
import SwiftUI

// ini buat nampilkan live kamera langsung di view
// pake UIViewRepresentable karena AVCaptureVideoPreviewLayer itu UIKit

struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> PreviewView {
        let view = PreviewView()
        view.session = session
        return view
    }

    func updateUIView(_ uiView: PreviewView, context: Context) {}

    // custom UIView buat preview layer
    class PreviewView: UIView {
        override class var layerClass: AnyClass {
            return AVCaptureVideoPreviewLayer.self
        }

        var previewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }

        var session: AVCaptureSession? {
            get { previewLayer.session }
            set {
                previewLayer.session = newValue
                previewLayer.videoGravity = .resizeAspectFill
            }
        }
    }
}

// ini ViewModel buat manage kamera session
class CameraViewModel: ObservableObject {
    @Published var isRunning = false
    @Published var errorMessage: String? = nil

    let session = AVCaptureSession()

    func setupAndStart() {
        // setup di background biar ga block main thread
        DispatchQueue.global(qos: .userInitiated).async {
            self.configureSession()
            self.session.startRunning()
            DispatchQueue.main.async {
                self.isRunning = self.session.isRunning
            }
        }
    }

    func stop() {
        session.stopRunning()
        isRunning = false
    }

    private func configureSession() {
        session.beginConfiguration()
        session.sessionPreset = .high

        // coba ambil kamera belakang dulu
        guard
            let camera = AVCaptureDevice.default(
                .builtInWideAngleCamera,
                for: .video,
                position: .back
            ),
            let input = try? AVCaptureDeviceInput(device: camera)
        else {
            DispatchQueue.main.async {
                self.errorMessage = ""
            }
            session.commitConfiguration()
            return
        }

        if session.canAddInput(input) {
            session.addInput(input)
        }

        session.commitConfiguration()
    }
}

// View utama yang nampilkan kamera + overlay UI
struct LiveCameraView: View {
    @StateObject private var cameraVM = CameraViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        
        
        
        ZStack {
            // background hitam waktu loading
            Color.black.ignoresSafeArea()

            if cameraVM.isRunning {
                // preview kamera
                CameraPreview(session: cameraVM.session)
                    .ignoresSafeArea()

                // overlay atas bawah biar ga polos
                VStack {
                    // top bar

                    Spacer()

                    // guide frame buat posisi badan
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            Color.white.opacity(0.5),
                            style: StrokeStyle(lineWidth: 2, dash: [10])
                        )
                        .frame(width: 200, height: 320, alignment: .center)


                    // hint di bawah
                    Text("Pastiin seluruh badan masuk frame ya")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.8))
                        .padding(.horizontal, 24)
                        .padding(.vertical, 10)
                        .background(.ultraThinMaterial, in: Capsule())
                        .padding(.bottom, 50)
                }.safeAreaInset(edge: .top) {
                    VStack {
                        // top bar
                        HStack {
                            Button {
                                cameraVM.stop()
                                dismiss()
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.title)
                                    .foregroundStyle(.white)
                                    .shadow(radius: 4)
                            }

                            Spacer()

                            Text("Live Camera")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .shadow(radius: 2)

                            Spacer()

                            // biar simetris
                            Color.clear.frame(width: 30)
                        }
                        .padding(.horizontal, 20)
                    }
                }

            } else if let err = cameraVM.errorMessage {
                // kalau error
                VStack(spacing: 16) {
                    Image(systemName: "camera.slash.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(.white.opacity(0.7))
                    Text(err)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                }

            } else {
                // loading state
                ProgressView()
                    .tint(.white)
            }
        }
        .onAppear {
            cameraVM.setupAndStart()
        }
        .onDisappear {
            cameraVM.stop()
        }
    }
}

#Preview {
    LiveCameraView()
}
