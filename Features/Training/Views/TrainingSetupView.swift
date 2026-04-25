import SwiftUI

struct TrainingSetupView: View {
    @State private var selectedStroke: String

    private var trainingType: TrainingModule.TrainingType {
        selectedStroke.lowercased().contains("back") ? .backhand : .forehand
    }

    @State private var viewModel = TrainingSessionViewModel()
    @State private var showGuide = false

    init() {
        // Tarik sinkron dari UserDefaults di init untuk menjamin tidak ada delay AppStorage
        let stroke = UserDefaults.standard.string(forKey: "selectedStroke") ?? ""
        _selectedStroke = State(initialValue: stroke)
    }

    var body: some View {
        VStack(spacing: Spacing.xl) {
            Text("Session Setup")
                .font(.poonaLargeTitle)
                .padding(.top, Spacing.xxxl)

            Text("Select your \(trainingType == .forehand ? "Forehand" : "Backhand") training duration")
                .font(.subheadline)
                .foregroundStyle(Color.appBlue)

            VStack(spacing: Spacing.md) {
                ForEach(SessionConfig.presets, id: \.duration) { config in
                    DurationButton(
                        config: config,
                        isSelected: viewModel.selectedConfig.duration == config.duration,
                        action: {
                            var updated = config
                            updated.trainingType = trainingType
                            viewModel.selectedConfig = updated
                        }
                    )
                }
            }

            Spacer()

            // "Start" → Navigasi ke layar How-To dulu, bukan langsung ke kamera
            Button {
                // Sinkronkan trainingType ke viewModel sebelum lanjut
                viewModel.selectedConfig.trainingType = trainingType
                showGuide = true
            } label: {
                Text("Start Training")
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.md)
                    .background(Color.poonaAccent)
                    .clipShape(RoundedRectangle(cornerRadius: Radius.full))
            }
        }
        .padding(.horizontal, Spacing.lg)
        .background(
            ZStack {
                Color(uiColor: .systemBackground).ignoresSafeArea()
                Color.appBlue.opacity(0.06).ignoresSafeArea()
            }
        )
        .onAppear {
            // Pastikan viewModel sinkron saat view muncul
            viewModel.selectedConfig.trainingType = trainingType
        }
        .navigationDestination(isPresented: $showGuide) {
            StrokeGuideView(strokeType: trainingType, viewModel: viewModel)
        }
    }
}

private struct DurationButton: View {
    let config: SessionConfig
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(config.displayText)
                    .foregroundStyle(Color.black)

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundStyle(Color.poonaAccent)
                }
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.vertical, Spacing.md)
            .background(isSelected ? Color.appBlue.opacity(0.15) : Color(uiColor: .systemBackground))
            .overlay(
                RoundedRectangle(cornerRadius: Radius.md)
                    .stroke(isSelected ? Color.appBlue : Color.clear, lineWidth: 2)
            )
            .clipShape(RoundedRectangle(cornerRadius: Radius.md))
        }
    }
}

#Preview {
    NavigationStack {
        TrainingSetupView()
    }
}
