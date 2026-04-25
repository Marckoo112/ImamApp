//
//  CameraSessionView.swift
//  ImamApp
//
//  Created by Sande Effendi on 16/04/26.
//

import SwiftUI
import AVFoundation

struct CameraSessionView: View {
    @Bindable var viewModel: TrainingSessionViewModel
    @Environment(\.dismiss) private var dismiss

    private let cameraState = CameraState()
    private let cameraManager: CameraSessionManager
    private let poseState = PoseDetectionState()
    private let poseService: PoseDetectionService
    private let previewSizeBox = PreviewSizeBox()
    @State private var videoDelegate: CameraSessionViewDelegate?
    @State private var showResult = false
    @State private var isLoadingCamera = true
    private let videoQueue = DispatchQueue(label: "com.poonaapp.video", qos: .userInitiated)

    init(viewModel: TrainingSessionViewModel) {
        self.viewModel = viewModel
        self.cameraManager = CameraSessionManager(state: cameraState)
        self.poseService = PoseDetectionService(state: poseState)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // MARK: Camera Feed
                CameraPreviewView(session: cameraManager.captureSession)
                    .ignoresSafeArea()
                    .onAppear {
                        previewSizeBox.size = geometry.size
                    }
                    .onChange(of: geometry.size) { _, newSize in
                        previewSizeBox.size = newSize
                    }

                // MARK: Joints / Pose Overlay
                JointsOverlayView(
                    detectedBody: poseState.detectedBody,
                    jointAngles: viewModel.jointAngles,
                    isFormValid: viewModel.isFormValid
                )
                .ignoresSafeArea()

                // MARK: Camera Loading Indicator
                if isLoadingCamera {
                    CameraLoadingView()
                }

                // MARK: Camera Error
                if case .failed(let message) = cameraState.state {
                    CameraErrorView(message: message, onDismiss: { dismiss() })
                }

                // MARK: Body Position Guide (before any stroke detected)
                if viewModel.sessionState == .idle && !isLoadingCamera {
                    BodyPositionGuideView()
                        .transition(.opacity)
                }

                // MARK: Ghost Silhouette + Countdown
                if case .countdown(let value) = viewModel.sessionState {
                    ZStack {
                        GhostSilhouetteView(strokeType: viewModel.selectedConfig.trainingType)
                        CountdownOverlayView(value: value)
                    }
                    .transition(.opacity)
                }

                // MARK: HUD
                VStack {
                    // Top row: Timer + Counter
                    if case .sessionActive = viewModel.sessionState {
                        HStack {
                            // Timer pill
                            HStack(spacing: 6) {
                                Image(systemName: "timer")
                                    .font(.caption)
                                Text(viewModel.formattedRemainingTime)
                                    .font(.system(size: 17, weight: .semibold, design: .monospaced))
                            }
                            .foregroundStyle(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(.black.opacity(0.55))
                            .clipShape(Capsule())

                            Spacer()

                            // Stroke counter pill
                            let count = viewModel.selectedConfig.trainingType == .forehand
                                ? viewModel.forehandCount : viewModel.backhandCount
                            let name = viewModel.selectedConfig.trainingType == .forehand ? "Forehand" : "Backhand"

                            HStack(spacing: 6) {
                                Image(systemName: "flame.fill")
                                    .font(.caption)
                                    .foregroundStyle(.orange)
                                Text("\(name) \(count)")
                                    .font(.system(size: 17, weight: .bold, design: .rounded))
                            }
                            .foregroundStyle(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(Color.appBlue.opacity(0.85))
                            .clipShape(Capsule())
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 52)
                    }

                    Spacer()

                    // Coaching tip (prominent, large pop-up in the middle-bottom)
                    if case .sessionActive = viewModel.sessionState {
                        Text(viewModel.coachingTip)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 28)
                            .padding(.vertical, 14)
                            .background(viewModel.isFormValid ? Color.green.opacity(0.85) : Color.red.opacity(0.85))
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            .shadow(color: .black.opacity(0.3), radius: 10, y: 4)
                            .padding(.bottom, 24)
                            .transition(.scale.combined(with: .opacity))
                            .id(viewModel.coachingTip) // triggers transition on text change
                    }

                    // Bottom: End button
                    Button {
                        endSessionAndNavigate()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 72, height: 72)
                                .shadow(color: .red.opacity(0.4), radius: 10, y: 4)
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.white)
                                .frame(width: 26, height: 26)
                        }
                    }
                    .padding(.bottom, 48)
                }
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: endSessionAndNavigate) {
                    HStack(spacing: 4) {
                        Image(systemName: "xmark")
                        Text("End")
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.black.opacity(0.45))
                    .clipShape(Capsule())
                }
            }
        }
        .navigationDestination(isPresented: $showResult) {
            ResultView(viewModel: viewModel)
        }
        .onAppear {
            startCamera()
        }
        .onDisappear {
            // Safety net: release kamera saat view hilang dari stack
            cameraManager.stopAndTeardown()
        }
        .onChange(of: cameraState.state) { _, newState in
            if newState == .running {
                withAnimation { isLoadingCamera = false }
                viewModel.startSession()
            } else if case .failed = newState {
                withAnimation { isLoadingCamera = false }
            }
        }
        .onChange(of: poseState.detectedBody) { _, newBody in
            viewModel.updateDetectedBody(newBody)
        }
        .onChange(of: viewModel.sessionState) { _, newState in
            if newState == .sessionEnded {
                navigateToResult()
            }
        }
    }

    // MARK: - Helpers

    private func startCamera() {
        isLoadingCamera = true
        videoDelegate = CameraSessionViewDelegate(poseService: poseService, previewSizeBox: previewSizeBox)
        Task {
            await cameraManager.prepareAndStart(delegate: videoDelegate!, queue: videoQueue)
        }
    }

    // Hentikan sesi latihan, lepas resource kamera, baru navigasi
    private func endSessionAndNavigate() {
        viewModel.stopSession()     // trigger .sessionEnded state
        cameraManager.stopAndTeardown()   // lepas resource kamera di background
    }

    private func navigateToResult() {
        cameraManager.stopAndTeardown()
        // Sedikit delay agar teardown selesai sebelum view baru dimuat
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            showResult = true
        }
    }
}

// MARK: - Ghost Silhouette
struct GhostSilhouetteView: View {
    let strokeType: TrainingModule.TrainingType
    @State private var pulse = 1.0

    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                // Dashed outline ring
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [8, 5]))
                    .foregroundStyle(.white.opacity(0.3))
                    .frame(width: 220, height: 220)

                VStack(spacing: 8) {
                    Image(systemName: strokeType == .forehand ? "figure.badminton" : "figure.badminton")
                        .font(.system(size: 110))
                        .foregroundStyle(.white.opacity(0.35))
                        .scaleEffect(x: strokeType == .backhand ? -1 : 1, y: 1)
                        .scaleEffect(pulse)
                }
            }

            Text("Align your body to the silhouette")
                .font(.system(.subheadline, design: .rounded).weight(.medium))
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(.black.opacity(0.45))
                .clipShape(Capsule())
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                pulse = 1.08
            }
        }
    }
}

// MARK: - Camera Loading
private struct CameraLoadingView: View {
    @State private var dotOpacity = 0.3

    var body: some View {
        ZStack {
            Color.black.opacity(0.7).ignoresSafeArea()
            VStack(spacing: 20) {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
                    .scaleEffect(1.5)
                Text("Starting Camera…")
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(.white.opacity(0.85))
            }
        }
    }
}

// MARK: - Supporting Types

private final class PreviewSizeBox {
    var size: CGSize = .zero
}

private final class CameraSessionViewDelegate: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    let poseService: PoseDetectionService
    let previewSizeBox: PreviewSizeBox

    init(poseService: PoseDetectionService, previewSizeBox: PreviewSizeBox) {
        self.poseService = poseService
        self.previewSizeBox = previewSizeBox
        super.init()
    }

    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        let size = previewSizeBox.size
        guard size != .zero else { return }
        poseService.processFrame(sampleBuffer, previewSize: size)
    }
}

// MARK: - Camera Error View
private struct CameraErrorView: View {
    let message: String
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 24) {
                Image(systemName: "video.slash.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.red)

                Text("Camera Unavailable")
                    .font(.system(.title2, design: .rounded).weight(.bold))
                    .foregroundStyle(.white)

                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                Button(action: onDismiss) {
                    Text("Go Back")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 36)
                        .padding(.vertical, 14)
                        .background(Color.appBlue)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.top, 8)
            }
        }
    }
}

#Preview {
    NavigationStack {
        CameraSessionView(viewModel: TrainingSessionViewModel())
    }
}
