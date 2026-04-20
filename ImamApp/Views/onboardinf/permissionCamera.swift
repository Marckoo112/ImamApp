import AVFoundation
import SwiftUI

struct permissionCamera: View {
    @Environment(AppState.self) private var appState
    @State private var isGranted = false
    @State private var showAlert = false
    @State private var iconBounce = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            Image(systemName: "camera.fill")
                .font(.system(size: 120))
                .foregroundColor(.red)

            Spacer().frame(height: 44)

            VStack(spacing: 12) {
                Text("Enable Camera\nAccess")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text(
                    "We use your camera to analyze your stroke and provide real-time feedback."
                )
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            }

            Spacer().frame(height: 32)

            // tips sebelum mulai
            VStack(alignment: .leading, spacing: 16) {
                Text("Before you start")
                    .font(.headline)

                TipRow(
                    icon: "person.fill",
                    text: "Keep your full body in frame",
                    color: .appBlue
                )
                TipRow(
                    icon: "ruler.fill",
                    text: "Stand 2–3 meters away",
                    color: .appOrange
                )
                TipRow(
                    icon: "sun.max.fill",
                    text: "Ensure good lighting",
                    color: .appPink
                )
            }
            .padding(20)
            .padding(.horizontal, 28)

            Spacer()

            VStack(spacing: 12) {
                if isGranted {
                    Button {
                        completeOnboarding()
                    } label: {
                        Text("Continue")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }.buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .tint(.red)
                        .padding(.horizontal, 28)
                } else {
                    Button {
                        handlePermission()
                    } label: {
                        Text("Continue")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }.buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .tint(.red)
                        .padding(.horizontal, 28)
                }

            }
            .padding(.bottom, 50)
        }
        .background(Color(.systemBackground))
        .navigationTitle("Setup")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            iconBounce = true
            // cek kalau sebelumnya udah pernah allow
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            if status == .authorized {
                isGranted = true
            }
        }
        .alert("Camera Access Needed", isPresented: $showAlert) {
            Button("Go to Settings") { openSettings() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Please enable camera access in Settings to continue.")
        }
    }

    func handlePermission() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .notDetermined:
            requestPermission()
        case .authorized:
            isGranted = true
            completeOnboarding()
        case .denied, .restricted:
            showAlert = true
        @unknown default:
            break
        }
    }

    func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                isGranted = granted
                if granted {
                    completeOnboarding()
                } else {
                    showAlert = true
                }
            }
        }
    }

    func completeOnboarding() {
        appState.hasCompletedOnboarding = true
    }

    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

// komponen kecil buat row tips
private struct TipRow: View {
    let icon: String
    let text: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(color)
                .frame(width: 24)
            Text(text)
                .font(.subheadline)
        }
    }
}

#Preview {
    NavigationStack {
        permissionCamera()
    }
}
