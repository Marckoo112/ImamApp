import SwiftUI

struct homeViews: View {
    @State private var goToTraining = false
    @State private var showCameraGuide = false
    @AppStorage("selectedHand") var selectedHand: String = ""
    @AppStorage("selectedStroke") var selectedStroke: String = ""

    @StateObject private var viewModel = HomeViewModel()

    private var sessionCount: Int {
        viewModel.lastSession == nil ? 0 : 1
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                // Ice Blue Subtle Branded Background
                ZStack {
                    Color(uiColor: .systemBackground).ignoresSafeArea()
                    Color.appBlue.opacity(0.06).ignoresSafeArea()
                }

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {

                        HStack(alignment: .center, spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Dashboard")
                                    .font(
                                        .system(
                                            size: 34,
                                            weight: .bold,
                                            design: .rounded
                                        )
                                    )
                                    .foregroundColor(.primary)
                            }
                            BadmintonLogoView(size: 38)
                        }
                        .padding(.horizontal, 24)

                        

                        SessionRingWidget(value: sessionCount)

                        if let last = viewModel.lastSession {
                            VStack(alignment: .leading, spacing: 14) {
                                LastSessionOverviewCard(summary: last)
                                    .padding(.horizontal, 24)
                            }
                        }

                        VStack(alignment: .leading, spacing: 14) {
                            Text("Training Mode")
                                .font(
                                    .system(
                                        size: 18,
                                        weight: .bold,
                                        design: .rounded
                                    )
                                )
                                .padding(.horizontal, 24)

                            NavigationLink(destination: StrokePickerPage()) {
                                HStack(spacing: 16) {
                                    ZStack {
                                        RoundedRectangle(
                                            cornerRadius: 12,
                                            style: .continuous
                                        )
                                        .fill(Color.appBlue.opacity(0.12))
                                        .frame(width: 48, height: 48)
                                        Image(systemName: "figure.tennis")
                                            .font(.system(size: 22))
                                            .foregroundColor(.appBlue)
                                    }

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Target Stroke")
                                            .font(
                                                .system(
                                                    size: 16,
                                                    weight: .semibold,
                                                    design: .rounded
                                                )
                                            )
                                            .foregroundColor(.primary)
                                        Text(
                                            selectedStroke.isEmpty
                                                ? "Tap to configure"
                                                : selectedStroke.uppercased()
                                        )
                                        .font(.system(size: 14))
                                        .foregroundColor(.secondary)
                                    }

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .font(
                                            .system(size: 14, weight: .semibold)
                                        )
                                        .foregroundColor(
                                            Color(uiColor: .tertiaryLabel)
                                        )
                                }
                                .padding(16)
                                .background(Color(uiColor: .systemBackground))
                                .clipShape(
                                    RoundedRectangle(
                                        cornerRadius: 20,
                                        style: .continuous
                                    )
                                )
                                .shadow(
                                    color: .appBlue.opacity(0.04),
                                    radius: 8,
                                    x: 0,
                                    y: 4
                                )
                            }
                            .padding(.horizontal, 24)
                        }

                        Button {
                            showCameraGuide = true
                        } label: {
                            HStack(spacing: 16) {
                                Image(systemName: "camera.viewfinder")
                                    .font(.system(size: 20, weight: .regular))
                                    .foregroundColor(.secondary)

                                Text("Camera Setup Guide")
                                    .font(
                                        .system(
                                            size: 15,
                                            weight: .medium,
                                            design: .rounded
                                        )
                                    )
                                    .foregroundColor(.primary)

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(
                                        Color(uiColor: .tertiaryLabel)
                                    )
                            }
                            .padding(16)
                            .background(Color(uiColor: .systemBackground))
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 16,
                                    style: .continuous
                                )
                            )
                            .shadow(
                                color: .appBlue.opacity(0.04),
                                radius: 6,
                                x: 0,
                                y: 3
                            )
                        }
                        .padding(.horizontal, 24)

                        Spacer().frame(height: 120)
                    }
                }

                VStack {
                    Button {
                        goToTraining = true
                    } label: {
                        Text("Start Training")
                            .font(
                                .system(
                                    size: 18,
                                    weight: .bold,
                                    design: .rounded
                                )
                            )
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color.appBlue)
                            .foregroundColor(.white)
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 30,
                                    style: .continuous
                                )
                            )

                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                    .background(
                        LinearGradient(
                            stops: [
                                .init(
                                    color: Color(uiColor: .systemBackground)
                                        .opacity(0),
                                    location: 0
                                ),
                                .init(
                                    color: Color(uiColor: .systemBackground),
                                    location: 0.85
                                ),
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .ignoresSafeArea()
                    )
                }
            }
            .fullScreenCover(
                isPresented: $goToTraining,
                onDismiss: {
                    viewModel.loadLastSession()
                }
            ) {
                NavigationStack {
                    TrainingSetupView()
                }
            }
            .onReceive(
                NotificationCenter.default.publisher(for: .sessionCompleted)
            ) { _ in
                // Dismiss fullScreenCover dan refresh lastSession
                goToTraining = false
            }
            .sheet(isPresented: $showCameraGuide) {
                CameraGuideView()
            }
        }
    }
}

private struct SessionRingWidget: View {
    let value: Int

    var body: some View {
        ZStack {
            // Lebar luar sebagai glow pudar
            Circle()
                .fill(Color.appBlue.opacity(0.04))
                .frame(width: 250, height: 250)

            // Ring utama lingkaran penuh
            Circle()
                .stroke(Color.appSky.opacity(0.8), lineWidth: 12)
                .frame(width: 220, height: 220)

            // Dot penanda di atas
            let progress: CGFloat =
                value == 0 ? 0 : min(CGFloat(value) / 10.0, 1.0)
            Circle()
                .fill(Color.appBlue)
                .frame(width: 18, height: 18)
                // Y offset is half of the stroke circle width (220)
                .offset(y: -110)
                .rotationEffect(.degrees(Double(progress) * 360))

            // Teks Tengah
            VStack(spacing: 4) {
                Text("\(value)")
                    .font(.system(size: 80, weight: .bold, design: .rounded))
                    .foregroundColor(.appBlue)
                    .padding(.bottom, -4)

                Text("Sessions")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)

                Text(value == 0 ? "Keep going!" : "Great job!")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .padding(.top, 2)
            }
        }
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
    }
}

private struct LastSessionOverviewCard: View {
    let summary: LastSessionSummary

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Focus: \(summary.strokeName)")
                        .font(
                            .system(size: 16, weight: .bold, design: .rounded)
                        )
                        .foregroundColor(.primary)
                    Text(summary.dateLabel)
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 24))
                    .foregroundColor(Color.appBlue)
            }

            Divider()

            VStack(alignment: .leading, spacing: 12) {
                ForEach(summary.feedbackItems.prefix(2), id: \.self) { item in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.appBlue.opacity(0.8))
                            .padding(.top, 2)

                        Text(item)
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineSpacing(2)
                    }
                }
            }
        }
        .padding(20)
        .background(Color(uiColor: .systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .appBlue.opacity(0.04), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    homeViews()
}
