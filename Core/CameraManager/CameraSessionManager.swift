//
//  CameraSessionManager.swift
//  PoonaApp
//
//  Created by Sande Effendi on 16/04/26.
//

import AVFoundation
import Observation

// MARK: - Camera State

@MainActor
@Observable
final class CameraState {

    enum SessionState: Equatable {
        case loading            // Sedang setup hardware
        case idle               // Siap, menunggu tubuh terdeteksi
        case running            // Kamera aktif dan streaming
        case failed(String)     // Gagal — bawa pesan error sebagai String agar Equatable

        static func == (lhs: SessionState, rhs: SessionState) -> Bool {
            switch (lhs, rhs) {
            case (.loading, .loading): return true
            case (.idle, .idle): return true
            case (.running, .running): return true
            case (.failed(let a), .failed(let b)): return a == b
            default: return false
            }
        }
    }

    var state: SessionState = .loading
    var isAuthorized: Bool = false

    // Helper untuk menampilkan error dari CameraError
    func setFailed(_ error: Error) {
        state = .failed(error.localizedDescription)
    }
}

// MARK: - Camera Session Manager

// Semua operasi hardware kamera berjalan di sessionQueue (background thread).
// Tidak ada satu pun operasi berat yang dijalankan di Main Thread.
final class CameraSessionManager: @unchecked Sendable {

    private let state: CameraState
    private let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "com.poonaapp.camera.session", qos: .userInitiated)
    private var videoOutput: AVCaptureVideoDataOutput?

    init(state: CameraState) {
        self.state = state
    }

    // MARK: - Public API

    /// Minta izin kamera → setup hardware → start streaming.
    /// Semua tahap berat dijalankan di background. Main Thread tidak diblokir.
    func prepareAndStart(delegate: AVCaptureVideoDataOutputSampleBufferDelegate, queue: DispatchQueue) async {
        let authorized = await requestAuthorization()
        guard authorized else { return }

        // Setup dan start dijalankan di background; tidak perlu await
        sessionQueue.async { [weak self] in
            guard let self else { return }
            self.setupSessionInternal()
            self.configureOutputInternal(delegate: delegate, queue: queue)
            self.startSessionInternal()
        }
    }

    /// Hentikan streaming dan bersihkan semua resource AVCaptureSession.
    func stopAndTeardown() {
        sessionQueue.async { [weak self] in
            guard let self else { return }
            if self.session.isRunning {
                self.session.stopRunning()
            }
            self.session.beginConfiguration()
            self.session.inputs.forEach { self.session.removeInput($0) }
            self.session.outputs.forEach { self.session.removeOutput($0) }
            self.session.commitConfiguration()
            self.videoOutput = nil
            Task { @MainActor in self.state.state = .idle }
        }
    }

    var captureSession: AVCaptureSession { session }

    // MARK: - Private — harus dipanggil dari sessionQueue

    private func requestAuthorization() async -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            await MainActor.run { state.isAuthorized = true }
            return true
        case .notDetermined:
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            await MainActor.run { state.isAuthorized = granted }
            if !granted {
                await MainActor.run { state.setFailed(CameraError.permissionDenied) }
            }
            return granted
        case .denied, .restricted:
            await MainActor.run {
                state.isAuthorized = false
                state.setFailed(CameraError.permissionDenied)
            }
            return false
        @unknown default:
            return false
        }
    }

    private func setupSessionInternal() {
        // Bersihkan konfigurasi lama sebelum setup baru
        session.beginConfiguration()
        session.inputs.forEach { session.removeInput($0) }
        session.outputs.forEach { session.removeOutput($0) }
        session.sessionPreset = .hd1920x1080

        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            session.commitConfiguration()
            Task { @MainActor in self.state.setFailed(CameraError.cameraUnavailable) }
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: camera)
            guard session.canAddInput(input) else {
                session.commitConfiguration()
                Task { @MainActor in self.state.setFailed(CameraError.cannotAddInput) }
                return
            }
            session.addInput(input)

            let output = AVCaptureVideoDataOutput()
            output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
            output.alwaysDiscardsLateVideoFrames = true

            guard session.canAddOutput(output) else {
                session.commitConfiguration()
                Task { @MainActor in self.state.setFailed(CameraError.cannotAddOutput) }
                return
            }
            session.addOutput(output)
            self.videoOutput = output
            session.commitConfiguration()

        } catch {
            session.commitConfiguration()
            Task { @MainActor in self.state.setFailed(error) }
        }
    }

    private func configureOutputInternal(delegate: AVCaptureVideoDataOutputSampleBufferDelegate, queue: DispatchQueue) {
        videoOutput?.setSampleBufferDelegate(delegate, queue: queue)
    }

    private func startSessionInternal() {
        guard !session.isRunning else { return }
        session.startRunning()
        Task { @MainActor in self.state.state = .running }
    }
}

// MARK: - Camera Errors

enum CameraError: LocalizedError {
    case cameraUnavailable
    case cannotAddInput
    case cannotAddOutput
    case permissionDenied

    var errorDescription: String? {
        switch self {
        case .cameraUnavailable: return "Camera is not available on this device."
        case .cannotAddInput:    return "Cannot configure camera input."
        case .cannotAddOutput:   return "Cannot configure camera output."
        case .permissionDenied:  return "Camera access was denied. Please go to Settings → Privacy → Camera to enable it."
        }
    }
}
